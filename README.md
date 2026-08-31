# Jarvis-Hermes

Cloud-first personal AI assistant built around **NousResearch Hermes Agent** and an optional-free-first **OmniRoute** routing layer.

## Project goals

- Use Hermes Agent as the core agent/orchestrator.
- Keep LLM inference in the cloud. **No local LLM.**
- Use **OmniRoute** as the primary multi-provider gateway once the Hermes baseline is installed.
- Prefer free cloud providers/models and automatic fallback when a route is unavailable or rate-limited.
- Target Windows Desktop as the normal user interface.
- Voice-first interaction: microphone → cloud STT → Hermes → OmniRoute → cloud LLM → TTS.
- Computer control, browser automation, files, memory, skills, and safe approvals.
- Keep the local footprint as small as practical. Gateway/runtime processes are local; model inference remains remote.
- Build incrementally and test every milestone before adding the next one.

## Explicitly out of scope

- Ollama
- Gemma/Llama/Qwen/Mistral local models
- Local GGUF inference
- Docker/Redis unless a later feature actually requires them
- Rebuilding VoiceOS
- Running any LLM inference on the user's PC

## Architecture

```text
User
  ↓
Jarvis / Hermes Desktop
  ↓
Hermes Agent
  ↓
OmniRoute (local gateway)
  ↓
Free / cloud AI providers
  ├─ provider A
  ├─ provider B
  ├─ provider C
  └─ provider ...
  ↓
auto routing + fallback
  ↓
Cloud LLM
  ↓
Hermes tools / agent loop
  ├─ Browser
  ├─ Computer Use
  ├─ Files
  ├─ Web / research
  ├─ Memory
  └─ Skills
```

Voice:

```text
Microphone
  ↓
Wake word (lightweight/local)
  ↓
Cloud STT
  ↓
Hermes
  ↓
OmniRoute
  ↓
Cloud LLM
  ↓
TTS
  ↓
Speaker
```

## Current upstream

This project is a thin project/configuration/integration layer around Hermes Agent and the upstream OmniRoute project. We do not fork or copy either source tree unless there is a concrete reason to do so.

- Hermes Agent: https://github.com/NousResearch/hermes-agent
- OmniRoute: https://github.com/diegosouzapw/OmniRoute

## Routing policy

- Start with OmniRoute's `auto` route after the gateway is configured.
- Prefer free cloud routes where they satisfy Hermes' tool/context requirements.
- Allow automatic fallback to another eligible route when a provider/model is unavailable or rate-limited.
- Do not assume free-tier availability is permanent; provider quotas and catalogs can change.
- Keep Hermes' own provider fallback available as a secondary safety net where configured.

## Milestones

1. Hermes Desktop + working cloud model baseline
2. OmniRoute gateway + free-provider auto routing
3. Voice input/output
4. Wake word (`Hey Jarvis` target)
5. Core tools
6. Computer Use
7. Vision/screen understanding
8. Persistent memory
9. High-value Skills
10. Calendar integration
11. Scheduled automation
12. Reliability, recovery, and provider rotation hardening

## Development rule

Research → Verify → Install → Test → Fix → Retest → Integrate.

Never stack several untested changes together. Never commit secrets.
