$ErrorActionPreference = 'Stop'

Write-Host "=== Jarvis-Hermes / OmniRoute Windows Setup ===" -ForegroundColor Cyan

if ($env:OS -ne 'Windows_NT') {
    throw "This script is for native Windows."
}

$node = Get-Command node.exe -ErrorAction SilentlyContinue
$npm = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $node -or -not $npm) {
    throw "Node.js/npm is required. Run scripts/setup_windows.ps1 first."
}

$nodeVersion = (& $node.Source --version).Trim()
Write-Host "Node.js: $nodeVersion" -ForegroundColor Green

Write-Host "Installing OmniRoute from the official npm package..." -ForegroundColor Yellow
& $npm.Source install -g omniroute --legacy-peer-deps
if ($LASTEXITCODE -ne 0) {
    throw "OmniRoute installation failed with exit code $LASTEXITCODE."
}

$omni = Get-Command omniroute.cmd -ErrorAction SilentlyContinue
if (-not $omni) {
    $omni = Get-Command omniroute.exe -ErrorAction SilentlyContinue
}
if (-not $omni) {
    Write-Warning "OmniRoute installed but the command is not visible in this shell yet. Open a NEW PowerShell window and run: omniroute"
    exit 0
}

Write-Host "OmniRoute command: $($omni.Source)" -ForegroundColor Green
Write-Host "Dashboard/API: http://localhost:20128" -ForegroundColor Cyan
Write-Host "OpenAI-compatible API: http://localhost:20128/v1" -ForegroundColor Cyan
Write-Host "Recommended routing model: auto" -ForegroundColor Cyan
Write-Host "No local LLM is installed or selected by this script." -ForegroundColor Cyan
