#!/usr/bin/env bash

set -euo pipefail

workspace=${WORKSPACE_FOLDER:-/workspace/finance-manager}
expected_ruby=${RUBY_VERSION:-3.4.10}
expected_bundler=${BUNDLER_VERSION:-2.7.2}
expected_rails=${RAILS_VERSION:-8.1.3}

fail() {
  printf 'post-create: %s\n' "$1" >&2
  exit 1
}

command -v ruby >/dev/null || fail "Ruby is required inside the app container"
command -v bundle >/dev/null || fail "Bundler is required inside the app container"
command -v rails >/dev/null || fail "Rails CLI is required inside the app container"
command -v psql >/dev/null || fail "PostgreSQL client is required inside the app container"
command -v git >/dev/null || fail "Git is required inside the app container"

actual_ruby=$(ruby -e 'print RUBY_VERSION')
actual_bundler=$(bundle --version | awk '{print $3}')
actual_rails=$(rails --version | awk '{print $2}')

[[ "$actual_ruby" == "$expected_ruby" ]] || fail "expected Ruby ${expected_ruby}, found ${actual_ruby}"
[[ "$actual_bundler" == "$expected_bundler" ]] || fail "expected Bundler ${expected_bundler}, found ${actual_bundler}"
[[ "$actual_rails" == "$expected_rails" ]] || fail "expected Rails ${expected_rails}, found ${actual_rails}"

install -d "$HOME/.cache" "$HOME/.local/state" /usr/local/bundle
if [[ -z "${BUNDLE_PATH:-}" ]]; then
  bundle config set --global path /usr/local/bundle
fi

if ! git config --global --get-all safe.directory 2>/dev/null | grep -Fxq "$workspace"; then
  git config --global --add safe.directory "$workspace"
fi

printf 'Ruby %s\n' "$actual_ruby"
printf 'Bundler %s\n' "$actual_bundler"
printf 'Rails %s\n' "$actual_rails"
psql --version

if [[ -f "$workspace/Gemfile" ]]; then
  bundle install
else
  printf 'post-create: Gemfile not found; bundle install skipped\n'
fi

printf 'post-create: environment ready; no application was generated\n'
