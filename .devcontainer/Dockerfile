ARG RUBY_VERSION=3.4.10
FROM ruby:${RUBY_VERSION}-bookworm AS toolchain

ARG BUNDLER_VERSION=2.7.2
ARG RAILS_VERSION=8.1.3
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=America/Sao_Paulo

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
      build-essential \
      ca-certificates \
      chromium \
      chromium-driver \
      curl \
      git \
      libpq-dev \
      libvips-tools \
      postgresql-client \
      ripgrep \
      shared-mime-info \
      tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler --version "${BUNDLER_VERSION}" --no-document \
    && gem install rails --version "${RAILS_VERSION}" --no-document \
    && groupadd --gid "${USER_GID}" "${USER_NAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USER_NAME}" \
    && mkdir -p /workspace/finance-manager /usr/local/bundle \
    && chown -R "${USER_UID}:${USER_GID}" /workspace /usr/local/bundle

RUN printf '%s\n' 'export PATH="/usr/local/bundle/bin:$PATH"' > /etc/profile.d/ruby-bundle-path.sh \
    && chmod 0644 /etc/profile.d/ruby-bundle-path.sh

ENV BROWSER_BIN=/usr/bin/chromium \
    CHROME_BIN=/usr/bin/chromium

FROM toolchain AS development

ARG USER_NAME=vscode

USER ${USER_NAME}
WORKDIR /workspace/finance-manager

CMD ["sleep", "infinity"]
