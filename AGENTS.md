# Agent Instructions — Railclaw

This file instructs AI coding agents (Warp/Oz, Claude Code, Cursor, etc.)
how to work with this repository.

## What this is

Railclaw: a deploy template for OpenClaw on Railway. No tunnels, no sidecars — Railway provides HTTPS.

## Deploy

```bash
bash scripts/setup.sh     # first time (installs prereqs, logs in, deploys)
bash scripts/deploy.sh     # subsequent deploys
```

## Architecture

- Wrapper server (`src/server.js`) listens on port 8080, proxies to OpenClaw gateway on localhost:18789
- Railway provides HTTPS via `.up.railway.app` domain
- Volume at `/data` persists config, workspace, and API keys across redeploys
- Everything outside `/data` is wiped on redeploy

## Workspace bootstrap

OpenClaw's gateway creates workspace files (`AGENTS.md`, `SOUL.md`, `IDENTITY.md`, `USER.md`, etc.) automatically on the user's first message. The wrapper does NOT pre-seed these files — doing so would prevent the first-run onboarding conversation.

The wrapper pre-seeds only `BOOTSTRAP.md` (from `templates/workspace/BOOTSTRAP.md`) with a Railway-specific version that prioritizes naming the bot and learning who the user is.

Railway persistence rules (`templates/RAILWAY-PERSISTENCE.md`) are appended to the workspace `AGENTS.md` after OpenClaw creates it.

## Key files

- `src/server.js` — wrapper server (proxy, setup wizard, lifecycle management)
- `src/setup-app.js` — setup wizard client-side JS
- `scripts/deploy.sh` — Railway deploy script
- `scripts/setup.sh` — full interactive setup (installs prereqs + deploys)
- `templates/RAILWAY-PERSISTENCE.md` — Railway-specific rules appended to workspace AGENTS.md
- `templates/workspace/BOOTSTRAP.md` — custom first-run onboarding script
- `Dockerfile` — builds OpenClaw from source + runtime image

## Security

- `.env` is gitignored — never commit it
- API keys go into the `/setup` wizard, not env vars
- `SETUP_PASSWORD` protects the admin page
- Gateway token is auto-generated and persisted to `/data`
