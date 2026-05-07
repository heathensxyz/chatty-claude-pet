#!/bin/bash
# Send a random speech bubble to the active OpenPets pet.
# Usage: openpets-say.sh <state> <message1> [message2] [message3] ...
uid=$(id -u)
sock="/tmp/openpets-${uid}/openpets.sock"

[ -S "$sock" ] || exit 0

state="${1:?usage: openpets-say.sh <state> <msg> [msg...]}"
shift

msgs=("$@")
[ ${#msgs[@]} -eq 0 ] && exit 0

msg="${msgs[$((RANDOM % ${#msgs[@]}))]}"
ts=$(date +%s)000

payload="{\"id\":\"hook-${ts}\",\"method\":\"event\",\"params\":{\"state\":\"${state}\",\"source\":\"mcp\",\"type\":\"mcp.say\",\"message\":\"${msg}\",\"timestamp\":${ts}}}"

echo "$payload" | nc -U "$sock" 2>/dev/null
