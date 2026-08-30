$ErrorActionPreference = 'Stop'

Write-Host "=== Jarvis-Hermes / Windows Cloud-Only Setup ===" -ForegroundColor Cyan

if ($env:OS -ne 'Windows_NT') {
    throw "This script is for native Windows. Use the official Hermes installer for your platform instead."
}

Write-Host "[1/4] Checking required commands..." -ForegroundColor Yellow
if (-not (Get-Command powershell -ErrorAction SilentlyContinue)) {
    throw "PowerShell is required."
}

Write-Host "[2/4] Ensuring local LLM runtimes are not being selected..." -ForegroundColor Yellow
$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollama) {
    Write-Warning "Ollama is installed on this machine. Jarvis-Hermes will NOT use it. This script does not remove Ollama."
}

Write-Host "[3/4] Installing/updating official Hermes Desktop..." -ForegroundColor Yellow
Write-Host "Using the official Hermes installer from Nous Research." -ForegroundColor DarkGray
& powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (irm https://hermes-agent.nousresearch.com/install.ps1)"
if ($LASTEXITCODE -ne 0) {
    throw "Hermes installer returned exit code $LASTEXITCODE."
}

Write-Host "[4/4] Verifying Hermes command..." -ForegroundColor Yellow
$hermes = Get-Command hermes -ErrorAction SilentlyContinue
if (-not $hermes) {
    Write-Warning "'hermes' was not found in the current PATH. Open a NEW PowerShell window and run: hermes doctor"
    exit 0
}

Write-Host "Hermes command: $($hermes.Source)" -ForegroundColor Green
Write-Host "Next: run 'hermes doctor' and configure a cloud provider from Hermes Desktop." -ForegroundColor Cyan
Write-Host "Do NOT configure Ollama or any local LLM." -ForegroundColor Cyan
