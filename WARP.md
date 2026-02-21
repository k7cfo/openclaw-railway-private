# Railclaw — Project Context

## What this is
Railclaw: a simplified fork of `vignesh07/clawdbot-railway-template` that deploys OpenClaw on Railway using Railway's built-in HTTPS. No tunnels or sidecars needed.

## Repo
- **GitHub:** https://github.com/k7cfo/railclaw
- **Upstream:** https://github.com/vignesh07/clawdbot-railway-template

## Key changes from upstream
- `src/server.js`: Added persistent extra env var system (`extra-env.json`) for saving Brave Search API key via setup wizard
- `src/server.js`: Brave Search API key input added to `/setup` wizard HTML
- `src/server.js`: Added automatic cleanup of orphaned gateway processes to prevent port conflicts and Telegram 401 errors
- `src/setup-app.js`: Sends `braveApiKey` in setup payload
- Added `scripts/deploy.sh` for one-command Railway deploy
- `src/server.js`: Workspace files are NOT pre-seeded — OpenClaw's gateway handles bootstrap (BOOTSTRAP.md, AGENTS.md, SOUL.md, etc.) on first message, triggering the onboarding conversation
- `src/server.js`: Railway persistence rules (`templates/RAILWAY-PERSISTENCE.md`) are appended to AGENTS.md after OpenClaw creates it (background poller)
- Added `docs/TELEGRAM.md` for comprehensive Telegram setup and troubleshooting
- Added `docs/TROUBLESHOOTING-401.md` for fixing 401 authentication errors
- Removed Tailscale and Cloudflare Tunnel (not needed — Railway provides HTTPS)

## Current deployment
- **Railway project:** `railclaw` (workspace K7)
- **Service:** `railclaw` (single service, no sidecar)
- **Public URL:** `https://<app>.up.railway.app` (Railway HTTPS)
- **Volume:** `/data` (5GB) for persistent state

## Architecture
- Wrapper server listens on port 8080, proxies to OpenClaw gateway on localhost:18789
- Railway provides HTTPS via `.up.railway.app` domain (TLS termination at Railway's edge)
- No tunnels, no sidecars, no extra DNS config

## Setup wizard
- URL: `/setup` — username `admin`, password = `SETUP_PASSWORD` env var
- Sections: (1) AI provider (OpenAI key), (2) Brave Search API key, (3) Chat platform token, (4) Run setup
- API keys are persisted to `/data/.openclaw/extra-env.json`

## "Deploy for friends" workflow
- Friend gets: OpenAI API key, Brave Search API key, picks a setup password
- Deployer runs `scripts/deploy.sh` with friend's SETUP_PASSWORD (default project name: `railclaw`)
- Friend visits `/setup` and pastes their keys

## Credentials
- `.env` has only `SETUP_PASSWORD` (and optional `RAILWAY_TOKEN`)
- API keys (OpenAI, Brave Search) go into the `/setup` wizard, not `.env`
- Check 1Password for keys
- `.env` is gitignored, never committed

## Naming convention
- **Railclaw** = this project/repo (the deploy wrapper)
- **OpenClaw** = the upstream product being deployed (never renamed)
- All `OPENCLAW_*` env vars reference the upstream product and are intentionally kept
- Default Railway project name: `railclaw`
- When used as a Railway template, projects deploy as `railclaw` (users can override via `PROJECT_NAME`)
