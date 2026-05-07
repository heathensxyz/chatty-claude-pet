# Chatty Claude Pet

Make your [OpenPets](https://github.com/anthropics/open-pets) desktop pet talk automatically when Claude Code events fire, with zero token cost.

By default, the `@open-pets/claude-pets` hooks update the pet's animation state (thinking, editing, celebrating) but don't trigger speech bubbles. Speech only happens when the AI explicitly calls `openpets_say` via MCP, which costs tokens and depends on the model remembering to do it.

This project adds two shell scripts that send randomized speech bubbles directly over the OpenPets IPC socket, bypassing the MCP server entirely. The pet talks at key moments on its own, no AI involvement required.

## What it looks like

| Event | Animation | Speech |
|---|---|---|
| You submit a prompt | thinking | "On it!" / "Hold my coffee." / "Challenge accepted." |
| Claude runs a tool | editing/running | (animation only, no speech to avoid noise) |
| Claude needs permission | waiting | "Hey! I need your approval to continue." |
| Claude finishes | celebrating | "Nailed it." / "Chef's kiss." / "Mic drop." |
| Claude hits an error | error | "I blame the gremlins." / "Error 404: success not found." |

## Requirements

- macOS (uses Unix domain sockets and `nc -U`)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- [Bun](https://bun.sh) installed
- [OpenPets](https://github.com/anthropics/open-pets) desktop app running

## Setup

### 1. Install the scripts

Copy the two scripts somewhere on your PATH:

```bash
cp openpets-say.sh openpets-notify.sh ~/bin/
chmod +x ~/bin/openpets-say.sh ~/bin/openpets-notify.sh
```

Or clone this repo and add it to your PATH:

```bash
git clone https://github.com/heathensxyz/chatty-claude-pet.git
export PATH="$HOME/chatty-claude-pet:$PATH"
```

### 2. Add the MCP server (if you haven't already)

```bash
claude mcp add openpets -- bunx --bun @open-pets/mcp
```

This lets Claude call `openpets_say` during sessions for contextual messages (separate from the automatic hook speech).

### 3. Configure hooks

Copy the example config into your Claude Code settings:

**For a specific project** (recommended to start):
```bash
mkdir -p .claude
cp example-settings.local.json .claude/settings.local.json
```

**For all projects** (global):
```bash
cp example-settings.local.json ~/.claude/settings.local.json
```

If you already have a `settings.local.json`, merge the `hooks` section into it.

### 4. Update script paths

If you didn't install the scripts to `~/bin/`, update the paths in your `settings.local.json` to point to wherever you put them.

### 5. Customize the messages

Edit the quoted strings in each hook command. The format is:

```
openpets-say.sh <state> "message 1" "message 2" "message 3" ...
```

The script picks one message at random each time. States control the pet's animation: `thinking`, `success`, `error`, `waiting`.

## How it works

```
Claude Code event fires
        |
        v
claude-pets hook updates animation state
        |
        v
openpets-say.sh picks a random message
        |
        v
Sends JSON event over IPC socket (/tmp/openpets-{uid}/openpets.sock)
        |
        v
OpenPets app shows speech bubble
```

The IPC event format matches what `openpets_say` sends internally: `{state, source: "mcp", type: "mcp.say", message, timestamp}`. No changes to the OpenPets app or `claude-pets` package are needed.

## Design decisions

**Why not add speech to `claude-pets` directly?** Hooks and MCP speech are intentionally separate in OpenPets by design. This approach layers speech on top without modifying either package.

**Why shell scripts instead of a node package?** Minimal dependencies, easy to customize, trivial to debug. The scripts are 10 lines each.

**Why no speech on PreToolUse/Notification?** They fire too frequently. Having the pet talk every time Claude reads a file or runs a command gets noisy fast.

## Platform support

Currently macOS only. The scripts use Unix domain sockets (`/tmp/openpets-{uid}/openpets.sock`) and `nc -U`. Contributions for Linux and Windows (named pipes) are welcome.

## Credits

Built on top of [OpenPets](https://github.com/anthropics/open-pets) and [`@open-pets/claude-pets`](https://www.npmjs.com/package/@open-pets/claude-pets) by the OpenPets team.
