# Upstream Hermes Baseline

## Verified upstream facts

The project targets Hermes Agent `0.20.6` as the current upstream release verified for this build.

Hermes upstream requires Python `>=3.11,<3.14` in its current `pyproject.toml`.

Hermes Desktop is a native application for Windows, macOS, and Linux and uses the same Hermes Agent core/configuration as the CLI/gateway. Existing sessions, API keys, skills, and memory are shared across surfaces.

For an existing Hermes installation, the Desktop app can be launched with:

```bash
hermes desktop
```

The upstream Windows/macOS Desktop installer is the recommended installation path.

## Project constraints

- Windows is the primary target for Jarvis-Hermes.
- Cloud LLM inference only.
- No local LLM runtime.
- No Ollama.
- No large model downloads.
- Normal use should not require a terminal.
- Terminal is a setup/maintenance interface only.

## Source of truth

Always check the current upstream Hermes documentation before changing installation, provider, Desktop, voice, or Computer Use assumptions. Do not hard-code obsolete provider/model details into this repository.
