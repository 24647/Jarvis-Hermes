$ErrorActionPreference = 'Stop'

$base = 'http://localhost:20128'
$api = "$base/v1/models"

Write-Host "=== Jarvis-Hermes / OmniRoute Verification ===" -ForegroundColor Cyan

$omni = Get-Command omniroute.cmd -ErrorAction SilentlyContinue
if (-not $omni) {
    $omni = Get-Command omniroute.exe -ErrorAction SilentlyContinue
}
if (-not $omni) {
    throw "OmniRoute command not found. Install with scripts/setup_omniroute_windows.ps1 and reopen PowerShell."
}

try {
    $health = Invoke-WebRequest -UseBasicParsing -Uri "$base/" -TimeoutSec 15
    Write-Host "[OK] Dashboard responded: HTTP $($health.StatusCode)" -ForegroundColor Green
} catch {
    throw "OmniRoute is not reachable at $base. Start it with 'omniroute' first. Details: $($_.Exception.Message)"
}

try {
    $models = Invoke-WebRequest -UseBasicParsing -Uri $api -TimeoutSec 15
    Write-Host "[OK] OpenAI-compatible /v1/models responded: HTTP $($models.StatusCode)" -ForegroundColor Green
    if ($models.Content -match 'auto') {
        Write-Host "[OK] 'auto' routing model is present in the model response." -ForegroundColor Green
    } else {
        Write-Warning "The /v1/models response did not visibly contain 'auto'. Inspect the dashboard before configuring Hermes."
    }
} catch {
    throw "OmniRoute API is not responding at $api. Details: $($_.Exception.Message)"
}

Write-Host "Cloud-only invariant: this verification checks the gateway/API only; it does not install or start a local LLM." -ForegroundColor Cyan
