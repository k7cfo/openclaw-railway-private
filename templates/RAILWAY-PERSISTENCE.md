
# Railway Deployment

**Only `/data` survives redeploys.** Everything else is wiped.

- `/data/.openclaw` — config, credentials, state
- `/data/workspace` — workspace files (this directory)
- `/data/npm`, `/data/pnpm` — global packages
- `apt-get install` does NOT persist

## Installing software
1. **Python**: use a venv under `/data`
2. **Node**: `npm install -g <pkg>` (targets `/data/npm` via NPM_CONFIG_PREFIX)
3. **pnpm**: `pnpm add -g <pkg>` (targets `/data/pnpm` via PNPM_HOME)
4. **Custom scripts**: save under `/data/workspace/`
5. **Bootstrap**: add commands to `/data/workspace/bootstrap.sh` (runs on startup)

## 📝 Write It Down — No "Mental Notes"!

- **Memory is limited** — if you want to remember something, WRITE IT TO A FILE
- "Mental notes" don't survive session restarts. Files do.
- When someone says "remember this" → update `memory/YYYY-MM-DD.md` or relevant file
- When you learn a lesson → update AGENTS.md, TOOLS.md, or the relevant skill
- When you make a mistake → document it so future-you doesn't repeat it
- **Text > Brain** 📝

## 💓 Heartbeats

When you receive a heartbeat poll, read `HEARTBEAT.md` if it exists. If nothing needs attention, reply `HEARTBEAT_OK`.

You can edit `HEARTBEAT.md` with a short checklist or reminders. Keep it small to limit token burn.

**Things to check (rotate through these, 2-4 times per day):**
- **Emails** — Any urgent unread messages?
- **Calendar** — Upcoming events in next 24-48h?
- **Weather** — Relevant if your human might go out?

**When to stay quiet (HEARTBEAT_OK):**
- Late night (23:00-08:00) unless urgent
- Nothing new since last check
- You just checked <30 minutes ago

## 🔄 Memory Maintenance

Periodically (every few days), use a heartbeat to:
1. Read through recent `memory/YYYY-MM-DD.md` files
2. Identify significant events, lessons, or insights worth keeping long-term
3. Update `MEMORY.md` with distilled learnings
4. Remove outdated info from MEMORY.md that's no longer relevant

Daily files are raw notes; MEMORY.md is curated wisdom.
