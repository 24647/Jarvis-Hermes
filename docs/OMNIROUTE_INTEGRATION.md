# Hermes + OmniRoute Integration

## Purpose

OmniRoute is the routing layer for Jarvis-Hermes. Hermes remains the agent/orchestrator; OmniRoute handles multi-provider cloud routing and free-first fallback.

## Target architecture

```text
Jarvis / Hermes Desktop
        ↓
   Hermes Agent
        ↓
OmniRoute (local gateway)
        ↓
 cloud/free providers
        ↓
 model: auto
        ↓
 response
```

The important invariant is that **model inference remains remote**. OmniRoute is a local gateway process, not a local LLM.

## Official OmniRoute install on Windows

OmniRoute's current quick-start recommends the npm package and runs the dashboard/API on port `20128`:

```powershell
npm install -g omniroute --legacy-peer-deps
omniroute
```

The project documents `http://localhost:20128` for the dashboard and `http://localhost:20128/v1` for the OpenAI-compatible API. Node.js 22.x is supported by the current package requirements. Our Hermes installer already provisions a user-scoped Node.js 22 LTS runtime.

For Windows users, the npm path can still encounter registry/native-dependency problems. If npm installation fails, use the official OmniRoute documentation/install manager rather than modifying Hermes source.

## First provider

Open the dashboard:

`http://localhost:20128`

Then connect at least one eligible cloud/free provider using OmniRoute's Providers UI. Prefer providers that support Hermes' needs:

- chat completions
- at least 64K context where required by the current Hermes version
- tool calling for agent tasks
- vision when needed later

Do not assume that a provider or free model remains available permanently. OmniRoute's provider catalog and free tiers can change.

## Hermes endpoint configuration

Hermes supports a first-class custom OpenAI-compatible endpoint. Configure the main model as:

```yaml
model:
  default: auto
  provider: custom
  base_url: http://localhost:20128/v1
```

If OmniRoute's dashboard creates a gateway API key, store that secret in Hermes' secret storage/configuration rather than committing it to Git. Use `hermes model` → Custom endpoint to enter the URL, key, and model where practical.

The upstream Hermes documentation states that custom endpoints must implement `/v1/chat/completions` and that `config.yaml` is the source of truth for `model.provider`, `model.base_url`, and the model ID.

## Verification

Start OmniRoute, then run from the Jarvis-Hermes repository:

```powershell
.\scripts\verify_omniroute_windows.ps1
```

Expected checks:

- dashboard responds
- `/v1/models` responds
- `auto` is visible when exposed by the gateway

Then launch Hermes and verify a simple text request is routed through OmniRoute.

## Routing policy

Use `model: auto` as the default. Prefer free routes where they meet capability requirements. If a provider/model becomes unavailable or rate-limited, allow OmniRoute to route to another eligible provider/model.

Keep Hermes' own provider fallback available where it does not conflict with the gateway setup.

## Security

Do not enable unrestricted computer control just because OmniRoute is installed. Hermes approvals and computer-use safety remain enabled.

Do not expose:

- browser cookies
- passwords
- API keys
- private files

unless a specific authorized task requires them.

## Local resource expectations

OmniRoute consumes some local CPU/RAM for routing, its server, cache/database, and dashboard. It does not perform the heavy LLM inference locally. Measure the actual footprint on the target Windows machine before applying aggressive resource limits.
