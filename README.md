# Jarvis-Hermes

Cloud-first personal AI assistant built around **NousResearch Hermes Agent**.

## Project goals

- Use Hermes Agent as the core agent/orchestrator.
- Keep LLM inference in the cloud. **No local LLM.**
- Target Windows Desktop as the normal user interface.
- Voice-first interaction: microphone → cloud STT → Hermes → cloud LLM → TTS.
- Computer control, browser automation, files, memory, skills, and safe approvals.
- Keep the local footprint as small as practical.
- Build incrementally and test every milestone before adding the next one.

## Explicitly out of scope for the initial build

- Ollama
- Gemma/Llama/Qwen/Mistral local models
- Local GGUF inference
- Docker/Redis unless a later feature actually requires them
- OmniRoute until the direct Hermes + cloud-provider path is proven
- Rebuilding VoiceOS

## Architecture

```text
User
  ↓
Jarvis / Hermes Desktop
  ↓
Hermes Agent
  ↓
Cloud AI Provider
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
Cloud LLM
  ↓
TTS
  ↓
Speaker
```

## Current upstream

This project is a thin project/configuration layer around Hermes Agent. We do not copy the Hermes source tree unless there is a concrete reason to do so.

Upstream Hermes: https://github.com/NousResearch/hermes-agent

## Milestones

1. Hermes Desktop + cloud LLM + basic chat
2. Voice input/output
3. Wake word (`Hey Jarvis` target)
4. Core tools
5. Computer Use
6. Vision/screen understanding
7. Persistent memory
8. Skills
9. Calendar integration
10. Scheduled automation
11. Reliability and fallback
12. Optional OmniRoute integration

## Development rule

Research → Verify → Install → Test → Fix → Retest → Integrate.

Never stack several untested changes together. Never commit secrets.
