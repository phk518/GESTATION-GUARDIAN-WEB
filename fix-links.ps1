$dir = ".\pages"
Get-ChildItem $dir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = [System.IO.File]::ReadAllText($path)
    $fixed = $content.Replace("patient-detail-alice-r.html", "archive/patient-detail-alice-r.html")
    if ($content -ne $fixed) {
        [System.IO.File]::WriteAllText($path, $fixed)
        Write-Host "Fixed: $($_.Name)" -ForegroundColor Green
    }
}
Write-Host "Done" -ForegroundColor Cyan
