$ErrorActionPreference = "Stop"

Write-Host "=== Jarvis-Hermes / Hermes Customizations ===" -ForegroundColor Cyan

$hermesRoot = Join-Path $env:LOCALAPPDATA "hermes"
$ttsFile = Join-Path $hermesRoot "hermes-agent\tools\tts_tool.py"

if (-not (Test-Path $ttsFile)) {
    throw "Hermes TTS source not found: $ttsFile"
}

Write-Host "[1/3] Hermes TTS source found." -ForegroundColor Green

$backup = "$ttsFile.backup-before-jarvis-customizations"

if (-not (Test-Path $backup)) {
    Copy-Item $ttsFile $backup
    Write-Host "[2/3] Backup created." -ForegroundColor Green
}
else {
    Write-Host "[2/3] Existing backup preserved." -ForegroundColor Yellow
}

$content = Get-Content $ttsFile -Raw

if ($content -match 'language_aware\s*=\s*bool') {
    Write-Host "[3/3] Language-aware TTS customization already present." -ForegroundColor Green
    exit 0
}

$old = @"
    _edge_tts = _import_edge_tts()
    edge_config = tts_config.get("edge") or {}
    voice = edge_config.get("voice", DEFAULT_EDGE_VOICE)
    speed = float(edge_config.get("speed", tts_config.get("speed", 1.0)))
"@

$new = @"
    _edge_tts = _import_edge_tts()
    edge_config = tts_config.get("edge") or {}

    # Optional language-aware voice selection.
    # Disabled by default to preserve Hermes original behavior.
    language_aware = bool(edge_config.get("language_aware", False))

    if language_aware:
        arabic_voice = edge_config.get("arabic_voice", "ar-MA-JamalNeural")
        english_voice = edge_config.get("english_voice", "en-US-AriaNeural")

        # Arabic Unicode blocks.
        has_arabic = any(
            "\u0600" <= ch <= "\u06ff"
            or "\u0750" <= ch <= "\u077f"
            or "\u08a0" <= ch <= "\u08ff"
            for ch in text
        )

        voice = arabic_voice if has_arabic else english_voice
    else:
        voice = edge_config.get("voice", DEFAULT_EDGE_VOICE)

    speed = float(edge_config.get("speed", tts_config.get("speed", 1.0)))
"@

if (-not $content.Contains($old)) {
    throw "Expected Hermes TTS code block was not found. No changes were made."
}

$content = $content.Replace($old, $new)

Set-Content -Path $ttsFile -Value $content -Encoding UTF8 -NoNewline

Write-Host "Customization applied successfully." -ForegroundColor Green
