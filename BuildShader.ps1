# Build script for compiling HLSL shader
# Usage: .\BuildShader.ps1

$ShaderDir = Join-Path $PSScriptRoot "Controls"
$FxFile = Join-Path $ShaderDir "FadeImageBlur.fx"
$PsFile = Join-Path $ShaderDir "FadeImageBlur.ps"

# Find fxc.exe (HLSL compiler)
$FxcPaths = @(
    "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\fxc.exe",
    "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\fxc.exe"
)

$Fxc = $null
foreach ($path in $FxcPaths) {
    if (Test-Path $path) {
        $Fxc = $path
        break
    }
}

# If not found, search for it
if (-not $Fxc) {
    $kitsPath = "C:\Program Files (x86)\Windows Kits\10\bin"
    if (Test-Path $kitsPath) {
        $matches = Get-ChildItem -Path $kitsPath -Filter "fxc.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($matches) {
            $Fxc = $matches.FullName
        }
    }
}

if (-not $Fxc) {
    Write-Host "Error: fxc.exe not found. Please install Windows SDK." -ForegroundColor Red
    exit 1
}

Write-Host "Compiling shader..." -ForegroundColor Cyan
Write-Host "  Source: $FxFile" -ForegroundColor Gray
Write-Host "  Output: $PsFile" -ForegroundColor Gray
Write-Host "  Compiler: $Fxc" -ForegroundColor Gray
Write-Host ""

& $Fxc /T ps_3_0 /E main /Fo $PsFile $FxFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Shader compiled successfully!" -ForegroundColor Green
    Write-Host "  Rebuild the project to use the updated shader." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Shader compilation failed!" -ForegroundColor Red
    exit 1
}
