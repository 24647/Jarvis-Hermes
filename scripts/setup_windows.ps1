$ErrorActionPreference = 'Stop'

Write-Host "=== Jarvis-Hermes / Windows Cloud-Only Setup ===" -ForegroundColor Cyan

if ($env:OS -ne 'Windows_NT') {
    throw "This script is for native Windows. Use the official Hermes installer for your platform instead."
}

Write-Host "[1/5] Checking required commands..." -ForegroundColor Yellow
if (-not (Get-Command powershell -ErrorAction SilentlyContinue)) {
    throw "PowerShell is required."
}

$curl = Get-Command curl.exe -ErrorAction SilentlyContinue
if (-not $curl) {
    throw "curl.exe is required. Windows 10/11 normally includes it."
}

Write-Host "[2/5] Ensuring local LLM runtimes are not being selected..." -ForegroundColor Yellow
$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollama) {
    Write-Warning "Ollama is installed on this machine. Jarvis-Hermes will NOT use it. This script does not remove Ollama."
}

Write-Host "[3/5] Checking connectivity to the official Hermes installer..." -ForegroundColor Yellow
$installerUrl = "https://hermes-agent.nousresearch.com/install.ps1"
$tempInstaller = Join-Path $env:TEMP "jarvis-hermes-install.ps1"

try {
    & $curl.Source -fL --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 120 $installerUrl -o $tempInstaller
    if ($LASTEXITCODE -ne 0) {
        throw "curl.exe returned exit code $LASTEXITCODE."
    }
} catch {
    throw "Could not download the official Hermes installer. Verify DNS/HTTPS connectivity and try again. Details: $($_.Exception.Message)"
}

if (-not (Test-Path $tempInstaller)) {
    throw "The Hermes installer download completed without creating the expected file."
}

Write-Host "[4/5] Installing/updating official Hermes Desktop..." -ForegroundColor Yellow
Write-Host "Using the official Hermes installer from Nous Research." -ForegroundColor DarkGray
try {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $tempInstaller
    if ($LASTEXITCODE -ne 0) {
        throw "Hermes installer returned exit code $LASTEXITCODE."
    }
} finally {
    Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue
}

Write-Host "[5/5] Verifying Hermes command..." -ForegroundColor Yellow
$hermes = Get-Command hermes -ErrorAction SilentlyContinue
if (-not $hermes) {
    Write-Warning "'hermes' was not found in the current PATH. Open a NEW PowerShell window and run: hermes doctor"
    exit 0
}

Write-Host "Hermes command: $($hermes.Source)" -ForegroundColor Green
Write-Host "Next: run 'hermes doctor' and configure a cloud provider from Hermes Desktop." -ForegroundColor Cyan
Write-Host "Do NOT configure Ollama or any local LLM." -ForegroundColor Cyan
