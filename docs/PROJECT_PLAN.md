# Jarvis-Hermes Project Plan

## Principle

Jarvis-Hermes is a thin integration/configuration project around the upstream Hermes Agent and OmniRoute projects. Keep both upstream projects intact where possible; prefer configuration and documented integration points over forks and invasive patches.

## M0 — Repository baseline

Status: **READY**

- Repository initialized.
- Secret-safe `.gitignore` added.
- `.env.example` added.
- Project constraints documented.

## M1 — Hermes Desktop + cloud model baseline

Success criteria:

- Hermes Agent installed on Windows.
- Hermes launches successfully.
- No local LLM runtime/model is selected.
- Basic text conversation works with a currently available cloud model.
- Hermes diagnostics are clean enough to proceed.

The OpenCode Free model catalog is treated as dynamic and non-guaranteed; a model shown in a picker may become unavailable upstream. Do not hard-code a single free model as a permanent dependency.

## M2 — OmniRoute cloud routing + free-first fallback

Primary architecture:

Hermes Desktop → Hermes Agent → OmniRoute → `model: auto` → eligible cloud/free providers → automatic fallback.

Success criteria:

- Official OmniRoute package installed on Windows.
- Dashboard responds on `http://localhost:20128`.
- OpenAI-compatible API responds on `http://localhost:20128/v1`.
- A provider is connected in OmniRoute using its supported free/cloud authorization method.
- Hermes is configured with a custom OpenAI-compatible endpoint pointing at OmniRoute.
- Hermes can complete a basic chat through OmniRoute.
- Hermes/OmniRoute do not run a local LLM.
- Provider/model failure is recovered by OmniRoute routing to another eligible route when available.

Reference: https://github.com/diegosouzapw/OmniRoute

## M3 — Voice

- Microphone input.
- Cloud speech-to-text where practical.
- Text-to-speech using Edge TTS or another free supported backend.
- Confirm voice round-trip works without local LLM inference.

## M4 — Wake word

Target: `Hey Jarvis`.

Keep wake-word detection lightweight/local if supported; do not stream microphone audio continuously to the cloud merely for wake detection.

## M5 — Core tools

- Files
- Shell/tool execution
- Web/research
- Browser

Use approvals for risky actions.

## M6 — Computer Use

- Open/close applications.
- Keyboard/mouse interaction.
- Screen/application state where supported.
- Safe approval workflow.

Known constraint: Windows elevation/UIPI can block automation of elevated applications from a non-elevated Hermes process.

## M7 — Vision

Use cloud-capable vision models where practical. Do not install a large local VLM.

## M8 — Memory

- Persistent memories.
- Session continuity.
- No unnecessary storage of credentials/secrets.

## M9 — Skills

Create only high-value reusable skills first:

- coding/debugging
- research
- GitHub
- PC diagnostics

## M10 — Calendar

Add official OAuth/API integration only after core assistant is stable.

## M11 — Automation

Add scheduled tasks/cron after interactive voice and tool execution are reliable.

## M12 — Reliability and fallback hardening

Test and handle:

- network failures
- provider timeouts
- rate limits
- unavailable models
- tool failures
- microphone/TTS failures
- browser failures
- missing permissions
- OmniRoute startup failures

Errors must be understandable to the user and detailed enough in logs for debugging.

## Definition of done

The user can launch Jarvis from Windows Desktop, speak naturally, receive spoken answers, use cloud AI without a local LLM, and safely perform useful computer/browser/file tasks. OmniRoute provides free-first multi-provider routing and fallback where eligible routes are available.
