#!/usr/bin/env bash
# Every tool against a local Worker on a freshly loaded D1.
# Usage: ./e2e-local.sh <manuals-root>
set -euo pipefail

export MCP_URL=http://127.0.0.1:8787 DB_WRITE_TOKEN=test

npx wrangler dev --local --var "DB_WRITE_TOKEN:$DB_WRITE_TOKEN" > wrangler-dev.log 2>&1 &
trap "kill $! 2>/dev/null" EXIT

timeout 60 bash -c 'until curl -s -o /dev/null "$MCP_URL"; do sleep 1; done' || { cat wrangler-dev.log; exit 1; }
node load.mjs "$1"
node e2e.mjs
