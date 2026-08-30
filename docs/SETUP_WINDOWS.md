# Windows Setup — Cloud-Only Jarvis-Hermes

## Goal

Run Hermes Desktop on native Windows while keeping all LLM inference in the cloud.

## Non-goals

Do not install or configure:

- Ollama
- local Gemma/Llama/Qwen/Mistral models
- GGUF inference
- a local GPU LLM runtime

## Installation

From PowerShell in the cloned Jarvis-Hermes repository:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup_windows.ps1
```

The script uses the official Hermes installer from Nous Research. It does not download a model into this repository.

Then open a **new** PowerShell window and run:

```powershell
hermes doctor
```

For normal use, launch the desktop application rather than the terminal interface:

```powershell
hermes desktop
```

The official Hermes documentation states that the desktop app uses the same agent, configuration, API keys, sessions, skills, and memory as the CLI/gateway and supports Windows. 

## Cloud provider

Configure the first cloud provider from Hermes Desktop. The initial target is OpenRouter/free cloud models.

Do not put API keys into this repository. Use Hermes' provider settings or environment/user secrets.

## Verification

Run from the repository:

```powershell
.\scripts\verify_cloud_only.ps1
```

A machine may have Ollama installed for unrelated reasons; that is not a failure by itself. This project simply must not select or start a local Ollama model.

## Troubleshooting order

1. `hermes doctor`
2. Verify internet connectivity.
3. Verify the selected cloud provider/model in Hermes Desktop.
4. Check provider quota/rate-limit status.
5. Restart Hermes Desktop after changing provider credentials.
6. Only then troubleshoot voice, browser, or computer-use features.

## Resource expectation

Cloud-only means the large model inference is remote. Hermes Desktop, voice helpers, browser automation, and Windows integration still consume some local CPU/RAM. The goal is to avoid the large memory/CPU cost of local LLM inference, not to reach zero resource usage.
