# claude-ops image: everything pre-installed, so the container starts in seconds
# instead of running apt-get on every start.
# Built by GitHub Actions (.github/workflows/build.yml) -> ghcr.io/anzhe778/claude-ops:latest; local build also works:
#   docker build --pull -t claude-ops:local /share/Container/claudeops/build
FROM debian:bookworm-slim

ENV TZ=Europe/Warsaw \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git jq less nano procps ripgrep tmux cron tzdata \
      python3 python3-pil python3-reportlab python3-pypdf poppler-utils python3-jwt python3-requests python3-cryptography \
      python3-websocket \
      chromium xvfb xauth fonts-noto-cjk \
      nodejs npm docker.io \
 && ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone \
 && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /work
CMD ["/usr/local/bin/start.sh"]
