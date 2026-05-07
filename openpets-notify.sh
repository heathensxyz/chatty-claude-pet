#!/bin/bash
# Alert the user when Claude Code needs permission approval.
uid=$(id -u)
sock="/tmp/openpets-${uid}/openpets.sock"

[ -S "$sock" ] || exit 0

ts=$(date +%s)000
payload="{\"id\":\"perm-${ts}\",\"method\":\"event\",\"params\":{\"state\":\"waiting\",\"source\":\"mcp\",\"type\":\"mcp.say\",\"message\":\"Hey! I need your approval to continue.\",\"timestamp\":${ts}}}"

echo "$payload" | nc -U "$sock" 2>/dev/null
