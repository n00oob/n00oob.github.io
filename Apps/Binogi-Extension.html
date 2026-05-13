$api = "https://api.github.com/repos/n00oob/binogi-extension/releases/latest"
$response = Invoke-RestMethod -Uri $api
$zipUrl = $response.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -ExpandProperty browser_download_url

$destDir = Join-Path $env:LOCALAPPDATA "Extension"
$tempZip = Join-Path $env:TEMP "extension.zip"
$tempUnpack = Join-Path $env:TEMP "ext_temp_unpack"

if (Test-Path $tempUnpack) { Remove-Item $tempUnpack -Recurse -Force }
if (-not (Test-Path $destDir)) { New-Item -Path $destDir -ItemType Directory -Force }

Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $tempUnpack -Force

$sourcePath = Join-Path $tempUnpack "better one"
if (Test-Path $sourcePath) {
    Copy-Item -Path "$sourcePath\*" -Destination $destDir -Recurse -Force
} else {
    Write-Warning "Could not find 'better one' folder inside the zip."
}

Remove-Item $tempZip -Force
Remove-Item $tempUnpack -Recurse -Force

$destDir | Set-Clipboard
Write-Host "Path copied to clipboard: $destDir"
