ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    git \
    curl \
    tmux \
    nodejs \
    npm \
 && npm install -g @anthropic-ai/claude-code \
 && apt-get purge -y npm \
 && rm -rf /var/lib/apt/lists/*

# Install ttyd (architecture-aware)
RUN ARCH=$(uname -m) \
 && case "$ARCH" in \
      x86_64)  TTYD_ARCH="x86_64" ;; \
      aarch64) TTYD_ARCH="aarch64" ;; \
      armv7l)  TTYD_ARCH="armv7l" ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac \
 && curl -fsSL "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.${TTYD_ARCH}" \
    -o /usr/local/bin/ttyd \
 && chmod +x /usr/local/bin/ttyd

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
