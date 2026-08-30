# Jarvis-Hermes Project Plan

## Principle

Jarvis-Hermes is a thin integration/configuration project around the upstream Hermes Agent. Keep the upstream agent intact where possible; prefer configuration and documented integration points over forks and invasive patches.

## M0 — Repository baseline

Status: **READY**

- Repository initialized.
- Secret-safe `.gitignore` added.
- `.env.example` added.
- Project constraints documented.

## M1 — Cloud-only Hermes Desktop

Success criteria:

- Hermes Desktop installed on Windows.
- Hermes launches from the desktop application, not a terminal for normal use.
- A cloud provider is configured.
- No local LLM runtime/model is installed or selected.
- Basic text conversation works.
- Hermes diagnostics are clean enough to proceed.

Initial provider target: OpenRouter/free-compatible route, subject to current provider availability and quota.

## M2 — Voice

- Microphone input.
- Cloud speech-to-text where practical.
- Text-to-speech using a free supported backend where practical.
- Confirm voice round-trip works without local LLM inference.

## M3 — Wake word

Target: `Hey Jarvis`.

Keep wake-word detection lightweight/local if supported; do not stream microphone audio continuously to the cloud merely for wake detection.

## M4 — Core tools

- Files
- Shell/tool execution
- Web/research
- Browser

Use approvals for risky actions.

## M5 — Computer Use

- Open/close applications.
- Keyboard/mouse interaction.
- Screen/application state where supported.
- Safe approval workflow.

Known constraint: Windows elevation/UIPI can block automation of elevated applications from a non-elevated Hermes process.

## M6 — Vision

Use cloud-capable vision models where practical. Do not install a large local VLM.

## M7 — Memory

- Persistent memories.
- Session continuity.
- No unnecessary storage of credentials/secrets.

## M8 — Skills

Create only high-value reusable skills first:

- coding/debugging
- research
- GitHub
- PC diagnostics

## M9 — Calendar

Add official OAuth/API integration only after core assistant is stable.

## M10 — Automation

Add scheduled tasks/cron after interactive voice and tool execution are reliable.

## M11 — Reliability

Test and handle:

- network failures
- provider timeouts
- rate limits
- tool failures
- microphone/TTS failures
- browser failures
- missing permissions

Errors must be understandable to the user and detailed enough in logs for debugging.

## M12 — Optional OmniRoute

Only add OmniRoute after direct Hermes + cloud provider is stable. The purpose is provider aggregation/fallback, not to complicate the initial system.

## Definition of done

The user can launch Jarvis from Windows Desktop, speak naturally, receive spoken answers, use cloud AI without a local LLM, and safely perform useful computer/browser/file tasks.
