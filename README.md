# claude-ops image

A small Debian image for a home-lab "ops" container: Python, cron, tmux, Node, Docker CLI, and Chromium + Xvfb
(for a headed browser on a virtual screen). Everything is pre-installed so the container starts in seconds.

- `Dockerfile` – the package list
- `start.sh` – loads `/work/crontab`, starts cron, starts a Claude Code `remote-control` session in tmux and restarts it if it stops
- `.github/workflows/build.yml` – builds `ghcr.io/anzhe778/claude-ops:latest` on every change and on the 1st and 15th of each month

No secrets live here: logins, tokens and data are mounted from the host at runtime (`/root`, `/work`).
