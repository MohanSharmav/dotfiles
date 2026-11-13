#!/usr/bin/env bash
# Generic Linux setup script (delegates to setup_ubuntu.sh)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$DIR/setup_ubuntu.sh" "$@"
