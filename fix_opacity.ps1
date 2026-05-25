$files = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $newContent = [System.Text.RegularExpressions.Regex]::Replace(
        $content,
        '\.withOpacity\(([^)]+)\)',
        '.withValues(alpha: $1)'
    )
    [System.IO.File]::WriteAllText($file.FullName, $newContent)
    Write-Host "Fixed: $($file.Name)"
}
Write-Host "Done!"
