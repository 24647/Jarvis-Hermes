# Windows Setup — Cloud-Only Jarvis-Hermes

## Goal

Run Hermes Desktop on native Windows with **OmniRoute as the multi-provider cloud routing layer**, while keeping all LLM inference in the cloud.

## Non-goals

Do not install or configure:

- Ollama
- local Gemma/Llama/Qwen/Mistral models
- GGUF inference
- a local GPU LLM runtime
- VoiceOS

## Installation order

1. Install Hermes and its managed Windows dependencies.
2. Run `hermes doctor` and confirm the base installation is healthy.
3. Install OmniRoute from its official package.
4. Start OmniRoute and open its dashboard.
5. Connect one or more eligible free/cloud providers in OmniRoute.
6. Create an OmniRoute API key from its dashboard when required.
7. Point Hermes' Custom Endpoint at `http://localhost:20128/v1` and use `auto` as the model.
8. Verify a text request through the complete Hermes → OmniRoute → provider path.
9. Only then enable/test voice, browser, and computer-use workflows.

## Step 1 — Hermes

From PowerShell in the cloned Jarvis-Hermes repository:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup_windows.ps1
```

The script uses the official Hermes installer from Nous Research. It does not download a local LLM model.

Then open a **new** PowerShell window and run:

```powershell
hermes doctor
```

## Step 2 — OmniRoute

Hermes' installer already provides a compatible Node.js 22 LTS runtime on the target machine. Install OmniRoute using the official npm package:

```powershell
.\scripts\setup_omniroute_windows.ps1
```

Or, manually:

```powershell
npm install -g omniroute --legacy-peer-deps
```

Then start it:

```powershell
omniroute
```

The official OmniRoute documentation currently uses `http://localhost:20128` for the dashboard and `http://localhost:20128/v1` for the OpenAI-compatible API. 

## Step 3 — Connect free providers

Open:

`http://localhost:20128`

In the OmniRoute dashboard, connect one or more **currently available** free/cloud providers. Candidate providers may include Kiro, OpenCode Free, and Pollinations depending on current availability.

Do not assume any free model is permanent. Provider catalogs, quotas, authentication rules, and terms can change.

For best Hermes compatibility, prefer routes that support:

- chat completions
- at least 64K context where required by the current Hermes release
- tool calling for agent tasks
- multimodal/vision when using vision features later

## Step 4 — Create the gateway key

Use OmniRoute Dashboard → API Keys / Endpoints and create a key when the gateway requires authentication. Keep this key private.

Never commit the key to Git.

## Step 5 — Point Hermes to OmniRoute

Hermes supports OpenAI-compatible custom endpoints. Use the Hermes provider setup:

```text
hermes model
→ Custom endpoint
→ Base URL: http://localhost:20128/v1
→ API key: your OmniRoute gateway key (when required)
→ Model: auto
```

The current Hermes documentation identifies `config.yaml` as the source of truth for custom endpoint URL/provider/model configuration.

## Step 6 — Verify

With OmniRoute running:

```powershell
.\scripts\verify_omniroute_windows.ps1
```

Then run a basic Hermes request and verify that the model response succeeds.

## Normal daily use

The target UX is Hermes Desktop / Jarvis, not a terminal session. Terminal commands are for installation, diagnostics, and maintenance.

OmniRoute is a local gateway process that routes requests to remote providers. It is **not** a local LLM runtime.

## Startup

The target setup should allow the gateway and assistant components to start automatically with Windows login where supported. Keep this disabled until the complete Hermes + OmniRoute path has been tested successfully.

## Troubleshooting order

1. `hermes doctor`
2. Confirm OmniRoute is running at `http://localhost:20128`.
3. Run `scripts/verify_omniroute_windows.ps1`.
4. Check OmniRoute provider status and quota.
5. Confirm Hermes Custom Endpoint URL is exactly `http://localhost:20128/v1`.
6. Confirm the OmniRoute API key if API-key enforcement is enabled.
7. Test one simple text request.
8. Only then troubleshoot voice, browser, or computer-use features.

## Resource expectation

Cloud-only means heavy LLM inference is remote. Hermes Desktop, OmniRoute, voice helpers, browser automation, and Windows integration still consume local CPU/RAM. The goal is to avoid the large memory/CPU cost of local LLM inference, not to reach zero resource usage.
