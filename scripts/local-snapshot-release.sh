#!/usr/bin/env bash

set -Eeuo pipefail

function cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  echo "cleanup running"
}

trap cleanup SIGINT SIGTERM ERR EXIT

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"
REPO_ROOT="$(cd ${SCRIPT_DIR} && git rev-parse --show-toplevel)"

echo "${SCRIPT_NAME} is running... "

# Get new tags from the remote
git fetch --tags

# Get the latest tag name
# shellcheck disable=SC2046
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
echo "${latestTag}"

export GOVERSION=$(go version | awk '{print $3;}')

goreleaser --snapshot --skip-publish --rm-dist