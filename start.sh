#!/bin/bash
# claude-ops start script (baked into the image). Loads the cron jobs from /work/crontab, starts cron,
# and keeps the Claude Code "remote-control" session (tmux 'claude') alive: if it stops, it is restarted within a minute.

[ -f /work/crontab ] && crontab /work/crontab
cron

start_claude() {
  [ -x /root/.local/bin/claude ] || return 0          # not installed / not logged in yet
  # a note about the last session; if that session expired, remote-control gets stuck on a 404 -> start clean
  rm -f /root/.claude/projects/-work/bridge-pointer.json
  tmux new-session -d -s claude 'cd /work && /root/.local/bin/claude remote-control'
}

# Claude Code lives in /root (mounted, survives image updates) and its own auto-update was not running here,
# so update it on every container start - Watchtower restarts the container with each new image (every ~2 weeks).
if [ -x /root/.local/bin/claude ]; then
  timeout 300 /root/.local/bin/claude update 2>&1 | tail -2 || true
fi

start_claude
echo 'claude-ops ready'

# watchdog: restart the session if it ends (crash, network drop, server-side close)
while true; do
  sleep 60
  if [ -x /root/.local/bin/claude ] && ! tmux has-session -t claude 2>/dev/null; then
    echo "$(date '+%F %T') claude remote-control not running - restarting"
    start_claude
  fi
done
