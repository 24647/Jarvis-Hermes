$ErrorActionPreference = 'Stop'

Write-Host "=== Jarvis-Hermes / Cloud-Only Verification ===" -ForegroundColor Cyan

$failures = 0

function Check($name, $ok, $detail) {
    if ($ok) {
        Write-Host "PASS  $name" -ForegroundColor Green
    } else {
        Write-Host "FAIL  $name — $detail" -ForegroundColor Red
        $script:failures++
    }
}

$hermes = Get-Command hermes -ErrorAction SilentlyContinue
Check "Hermes command available" ($null -ne $hermes) "Open a new PowerShell session after installation."

if ($hermes) {
    try {
        & hermes --version
        Check "Hermes starts" ($LASTEXITCODE -eq 0) "Run 'hermes doctor' for diagnostics."
    } catch {
        Check "Hermes starts" $false $_.Exception.Message
    }
}

$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollama) {
    Write-Host "INFO  Ollama is installed, but this project is configured NOT to use it." -ForegroundColor Yellow
} else {
    Write-Host "PASS  No Ollama command detected (ideal for cloud-only setup)" -ForegroundColor Green
}

$envLocal = Join-Path (Get-Location) '.env'
Check "No project .env is committed" (-not (Test-Path $envLocal)) "Keep real credentials outside Git and use environment/user secrets."

Write-Host "`nTarget architecture: Jarvis-Hermes -> Hermes Agent -> Cloud Provider -> Cloud LLM" -ForegroundColor Cyan
Write-Host "Local LLM inference is intentionally unsupported in this project." -ForegroundColor Cyan

if ($failures -gt 0) {
    exit 1
}

Write-Host "`nCloud-only baseline checks passed." -ForegroundColor Green
