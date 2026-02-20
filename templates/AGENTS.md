# Railway Deployment — Persistence Rules

This OpenClaw instance runs on Railway with an ephemeral filesystem. **Only `/data` is persistent** (mounted as a Railway volume). Everything outside `/data` is wiped on every redeploy or restart.

## What persists (under /data)
- `/data/.openclaw` — OpenClaw config, credentials, state
- `/data/workspace` — your workspace (this file lives here)
- `/data/npm` — npm global packages (`npm install -g`)
- `/data/pnpm` — pnpm global packages
- `/data/pnpm-store` — pnpm content-addressable store

## What does NOT persist
- `apt-get install ...` (installs to `/usr/*`, wiped on redeploy)
- Files written outside `/data`
- Homebrew or system-level installs

## Rules for installing software
1. **Python packages**: always use a venv under `/data`:
   ```bash
   python3 -m venv /data/venv
   source /data/venv/bin/activate
   pip install <package>
   ```
2. **Node packages**: `npm install -g <pkg>` already targets `/data/npm` (pre-configured via NPM_CONFIG_PREFIX)
3. **pnpm packages**: `pnpm add -g <pkg>` already targets `/data/pnpm` (pre-configured via PNPM_HOME)
4. **Custom scripts**: save them under `/data/workspace/`
5. **Never** install via `apt-get` or write important files outside `/data`

## Bootstrap script
If you need tools reinstalled on every restart, add commands to `/data/workspace/bootstrap.sh`. The wrapper runs this script automatically on startup.

## Updating OpenClaw
To check your version: `openclaw --version`
To update: the deployment owner rebuilds the Docker image with a newer `OPENCLAW_GIT_REF` tag and redeploys.
