param(
    [Parameter(Mandatory = $true)]
    [string]$WebsiteRoot,

    [string]$BaseUrl = "https://serkal.de",

    [string]$OutputDir = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Normalize-RelativePath {
    param(
        [string]$SourceFile,
        [string]$Reference,
        [string]$Root
    )

    $ref = [System.Net.WebUtility]::HtmlDecode($Reference).Trim()

    if ([string]::IsNullOrWhiteSpace($ref)) { return $null }
    if ($ref.StartsWith("#")) { return $null }
    if ($ref -match '^(?i)(https?:|mailto:|tel:|javascript:|data:|blob:|ftp:)') { return $null }
    if ($ref.StartsWith("//")) { return $null }

    $withoutQuery = ($ref -split '[?#]', 2)[0]
    if ([string]::IsNullOrWhiteSpace($withoutQuery)) { return $null }

    $withoutQuery = $withoutQuery.Replace("/", [IO.Path]::DirectorySeparatorChar)

    if ($withoutQuery.StartsWith([IO.Path]::DirectorySeparatorChar)) {
        $candidate = Join-Path $Root $withoutQuery.TrimStart([IO.Path]::DirectorySeparatorChar)
    }
    else {
        $candidate = Join-Path (Split-Path -Parent $SourceFile) $withoutQuery
    }

    try {
        return [IO.Path]::GetFullPath($candidate)
    }
    catch {
        return $candidate
    }
}

function Get-CaseSensitiveMatch {
    param(
        [string]$FullPath,
        [string]$Root
    )

    if (-not $FullPath.StartsWith($Root, [StringComparison]::OrdinalIgnoreCase)) {
        return [pscustomobject]@{ Exists = $false; ExactCase = $false; ActualPath = $null }
    }

    $relative = $FullPath.Substring($Root.Length).TrimStart("\", "/")
    if ([string]::IsNullOrWhiteSpace($relative)) {
        return [pscustomobject]@{ Exists = $true; ExactCase = $true; ActualPath = $Root }
    }

    $current = $Root
    $exact = $true

    foreach ($part in ($relative -split '[\\/]')) {
        if ([string]::IsNullOrEmpty($part)) { continue }

        if (-not (Test-Path -LiteralPath $current -PathType Container)) {
            return [pscustomobject]@{ Exists = $false; ExactCase = $false; ActualPath = $null }
        }

        $entry = Get-ChildItem -LiteralPath $current -Force |
            Where-Object { $_.Name -ieq $part } |
            Select-Object -First 1

        if ($null -eq $entry) {
            return [pscustomobject]@{ Exists = $false; ExactCase = $false; ActualPath = $null }
        }

        if ($entry.Name -cne $part) { $exact = $false }
        $current = $entry.FullName
    }

    return [pscustomobject]@{
        Exists = (Test-Path -LiteralPath $current)
        ExactCase = $exact
        ActualPath = $current
    }
}

function Add-Issue {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Type,
        [string]$Severity,
        [string]$Source,
        [string]$Reference,
        [string]$Target,
        [string]$Details
    )

    $List.Add([pscustomobject]@{
        Type = $Type
        Severity = $Severity
        Source = $Source
        Reference = $Reference
        Target = $Target
        Details = $Details
    })
}

$root = [IO.Path]::GetFullPath($WebsiteRoot.Trim('"'))
if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    throw "Website-Ordner nicht gefunden: $root"
}

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $PSScriptRoot "output"
}
$output = [IO.Path]::GetFullPath($OutputDir)
New-Item -ItemType Directory -Path $output -Force | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$issues = [System.Collections.Generic.List[object]]::new()
$checkedReferences = 0
$filesScanned = 0

$htmlFiles = Get-ChildItem -LiteralPath $root -Recurse -File |
    Where-Object { $_.Extension -in @(".html", ".htm") }

$allFiles = Get-ChildItem -LiteralPath $root -Recurse -File
$allFileRelative = @{}
foreach ($file in $allFiles) {
    $rel = $file.FullName.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
    $allFileRelative[$rel.ToLowerInvariant()] = $rel
}

$attributePattern = '(?is)\b(?:href|src|action|poster)\s*=\s*(["''])(.*?)\1'
$cssUrlPattern = '(?is)url\(\s*(["'']?)(.*?)\1\s*\)'

foreach ($html in $htmlFiles) {
    $filesScanned++
    $sourceRel = $html.FullName.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
    $content = Get-Content -LiteralPath $html.FullName -Raw -Encoding UTF8

    $refs = [System.Collections.Generic.List[string]]::new()

    foreach ($match in [regex]::Matches($content, $attributePattern)) {
        $refs.Add($match.Groups[2].Value)
    }
    foreach ($match in [regex]::Matches($content, $cssUrlPattern)) {
        $refs.Add($match.Groups[2].Value)
    }

    foreach ($ref in $refs) {
        $target = Normalize-RelativePath -SourceFile $html.FullName -Reference $ref -Root $root
        if ($null -eq $target) { continue }

        $checkedReferences++
        $result = Get-CaseSensitiveMatch -FullPath $target -Root $root
        $targetRel = if ($target.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
            $target.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
        } else {
            $target
        }

        if (-not $result.Exists) {
            Add-Issue $issues "MISSING_TARGET" "ERROR" $sourceRel $ref $targetRel "Zieldatei oder Zielordner fehlt."
        }
        elseif (-not $result.ExactCase) {
            $actualRel = $result.ActualPath.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
            Add-Issue $issues "CASE_MISMATCH" "WARNING" $sourceRel $ref $targetRel "Groß-/Kleinschreibung stimmt nicht. Tatsächlich: $actualRel"
        }
    }
}

# sitemap.xml prüfen
$sitemapPath = Join-Path $root "sitemap.xml"
if (Test-Path -LiteralPath $sitemapPath -PathType Leaf) {
    try {
        [xml]$sitemap = Get-Content -LiteralPath $sitemapPath -Raw -Encoding UTF8
        $nodes = $sitemap.urlset.url
        foreach ($node in $nodes) {
            $loc = [string]$node.loc
            if ([string]::IsNullOrWhiteSpace($loc)) { continue }

            if ($loc.StartsWith($BaseUrl, [StringComparison]::OrdinalIgnoreCase)) {
                $pathPart = $loc.Substring($BaseUrl.TrimEnd("/").Length).TrimStart("/")
                if ([string]::IsNullOrWhiteSpace($pathPart)) {
                    $pathPart = "index.html"
                }

                $candidate = Join-Path $root ($pathPart.Replace("/", "\"))
                $result = Get-CaseSensitiveMatch -FullPath $candidate -Root $root
                if (-not $result.Exists) {
                    Add-Issue $issues "SITEMAP_DEAD_ENTRY" "ERROR" "sitemap.xml" $loc $pathPart "Sitemap verweist auf eine nicht vorhandene lokale Datei."
                }
                elseif (-not $result.ExactCase) {
                    Add-Issue $issues "SITEMAP_CASE_MISMATCH" "WARNING" "sitemap.xml" $loc $pathPart "Groß-/Kleinschreibung stimmt nicht."
                }
            }
        }

        $sitemapUrls = @($nodes | ForEach-Object { ([string]$_.loc).TrimEnd("/") })
        foreach ($html in $htmlFiles) {
            $rel = $html.FullName.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
            $url = if ($rel -ieq "index.html") { $BaseUrl.TrimEnd("/") } else { "$($BaseUrl.TrimEnd('/'))/$rel" }
            if ($sitemapUrls -notcontains $url.TrimEnd("/")) {
                Add-Issue $issues "NOT_IN_SITEMAP" "INFO" $rel "" $url "HTML-Datei ist nicht in sitemap.xml eingetragen."
            }
        }
    }
    catch {
        Add-Issue $issues "SITEMAP_INVALID" "ERROR" "sitemap.xml" "" "" "XML konnte nicht gelesen werden: $($_.Exception.Message)"
    }
}
else {
    Add-Issue $issues "SITEMAP_MISSING" "WARNING" "" "" "sitemap.xml" "Keine sitemap.xml im Website-Root gefunden."
}

# robots.txt prüfen
$robotsPath = Join-Path $root "robots.txt"
if (Test-Path -LiteralPath $robotsPath -PathType Leaf) {
    $robots = Get-Content -LiteralPath $robotsPath -Raw -Encoding UTF8
    if ($robots -notmatch '(?im)^\s*Sitemap\s*:\s*https?://') {
        Add-Issue $issues "ROBOTS_NO_SITEMAP" "WARNING" "robots.txt" "" "" "robots.txt enthält keinen Sitemap-Eintrag."
    }
}
else {
    Add-Issue $issues "ROBOTS_MISSING" "INFO" "" "" "robots.txt" "Keine robots.txt im Website-Root gefunden."
}

# identische HTML-Dateien erkennen
$hashGroups = $htmlFiles |
    ForEach-Object {
        [pscustomobject]@{
            File = $_.FullName.Substring($root.Length).TrimStart("\", "/").Replace("\", "/")
            Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
        }
    } |
    Group-Object Hash |
    Where-Object { $_.Count -gt 1 }

foreach ($group in $hashGroups) {
    $names = ($group.Group.File -join ", ")
    foreach ($item in $group.Group) {
        Add-Issue $issues "IDENTICAL_HTML" "INFO" $item.File "" "" "Dateiinhalt ist identisch mit: $names"
    }
}

# Bericht schreiben
$errors = @($issues | Where-Object Severity -eq "ERROR").Count
$warnings = @($issues | Where-Object Severity -eq "WARNING").Count
$infos = @($issues | Where-Object Severity -eq "INFO").Count

$summary = [pscustomobject]@{
    Timestamp = (Get-Date).ToString("s")
    WebsiteRoot = $root
    HtmlFilesScanned = $filesScanned
    ReferencesChecked = $checkedReferences
    Errors = $errors
    Warnings = $warnings
    Infos = $infos
}

$txtPath = Join-Path $output "website_check_$timestamp.txt"
$csvPath = Join-Path $output "website_check_$timestamp.csv"
$jsonPath = Join-Path $output "website_check_$timestamp.json"
$htmlPath = Join-Path $output "website_check_$timestamp.html"

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("============================================================")
$lines.Add(" ELWMS WEBSITE CHECK")
$lines.Add("============================================================")
$lines.Add("Root                : $root")
$lines.Add("HTML-Dateien        : $filesScanned")
$lines.Add("Referenzen geprüft  : $checkedReferences")
$lines.Add("Fehler              : $errors")
$lines.Add("Warnungen           : $warnings")
$lines.Add("Hinweise            : $infos")
$lines.Add("============================================================")
$lines.Add("")

foreach ($issue in $issues | Sort-Object Severity, Type, Source) {
    $lines.Add("[$($issue.Severity)] $($issue.Type)")
    if ($issue.Source) { $lines.Add("  Quelle : $($issue.Source)") }
    if ($issue.Reference) { $lines.Add("  Verweis: $($issue.Reference)") }
    if ($issue.Target) { $lines.Add("  Ziel   : $($issue.Target)") }
    $lines.Add("  Info   : $($issue.Details)")
    $lines.Add("")
}

if ($issues.Count -eq 0) {
    $lines.Add("Keine Auffälligkeiten gefunden.")
}

$lines | Set-Content -LiteralPath $txtPath -Encoding UTF8
$issues | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding UTF8
[pscustomobject]@{ Summary = $summary; Issues = $issues } |
    ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath $jsonPath -Encoding UTF8

$rows = foreach ($issue in $issues | Sort-Object Severity, Type, Source) {
    $sevClass = switch ($issue.Severity) {
        "ERROR" { "err" }
        "WARNING" { "warn" }
        default { "info" }
    }

    "<tr class='$sevClass'><td>$([Net.WebUtility]::HtmlEncode($issue.Severity))</td><td>$([Net.WebUtility]::HtmlEncode($issue.Type))</td><td>$([Net.WebUtility]::HtmlEncode($issue.Source))</td><td>$([Net.WebUtility]::HtmlEncode($issue.Reference))</td><td>$([Net.WebUtility]::HtmlEncode($issue.Target))</td><td>$([Net.WebUtility]::HtmlEncode($issue.Details))</td></tr>"
}

$htmlReport = @"
<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<title>ELWMS Website Check</title>
<style>
body{font-family:Arial,sans-serif;background:#111827;color:#e5e7eb;margin:24px}
h1{margin-bottom:6px}
.summary{display:flex;gap:16px;flex-wrap:wrap;margin:18px 0}
.card{background:#1f2937;padding:12px 16px;border-radius:8px}
table{border-collapse:collapse;width:100%;background:#1f2937}
th,td{border:1px solid #374151;padding:8px;text-align:left;vertical-align:top}
th{background:#374151}
.err{background:#4c1d1d}
.warn{background:#4a350d}
.info{background:#172554}
code{color:#93c5fd}
</style>
</head>
<body>
<h1>ELWMS Website Check</h1>
<div><code>$([Net.WebUtility]::HtmlEncode($root))</code></div>
<div class="summary">
<div class="card">HTML-Dateien: <strong>$filesScanned</strong></div>
<div class="card">Referenzen: <strong>$checkedReferences</strong></div>
<div class="card">Fehler: <strong>$errors</strong></div>
<div class="card">Warnungen: <strong>$warnings</strong></div>
<div class="card">Hinweise: <strong>$infos</strong></div>
</div>
<table>
<thead><tr><th>Stufe</th><th>Typ</th><th>Quelle</th><th>Verweis</th><th>Ziel</th><th>Information</th></tr></thead>
<tbody>
$($rows -join "`n")
</tbody>
</table>
</body>
</html>
"@

$htmlReport | Set-Content -LiteralPath $htmlPath -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host " ELWMS WEBSITE CHECK - FERTIG"
Write-Host "============================================================"
Write-Host "HTML-Dateien       : $filesScanned"
Write-Host "Referenzen geprüft : $checkedReferences"
Write-Host "Fehler             : $errors"
Write-Host "Warnungen          : $warnings"
Write-Host "Hinweise           : $infos"
Write-Host ""
Write-Host "Bericht:"
Write-Host "  $htmlPath"
Write-Host "============================================================"

Start-Process $htmlPath

if ($errors -gt 0) { exit 2 }
if ($warnings -gt 0) { exit 1 }
exit 0
