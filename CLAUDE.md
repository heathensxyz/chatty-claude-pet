# Chatty Claude Pet

This project adds speech bubble hooks to OpenPets for Claude Code. The speech messages live in `.claude/settings.local.json` (or `~/.claude/settings.local.json` for global) inside the `hooks` object.

## Personalizing speech

When the user asks you to personalize, refresh, or update their pet's speech messages, follow this process:

1. Read the current `settings.local.json` that contains the hooks
2. Look at the existing message pools in each hook command (the quoted strings after `openpets-say.sh <state>`)
3. Generate new messages that match the user's personality, humor, and communication style
4. Replace the message pools in the hook commands, keeping the script path and state argument unchanged

### Message guidelines

- Keep messages short, 2-8 words. They appear in small speech bubbles.
- Write 15-30 messages per event. More variety means less repetition.
- Match the user's tone. If they're sarcastic, be sarcastic. If they're earnest, be earnest.
- Each event type has a mood:
  - `thinking` messages: the pet just received a task (curious, eager, focused)
  - `success` messages: the pet just finished (proud, relieved, playful)
  - `error` messages: something went wrong (sheepish, self-deprecating, reassuring)
  - `waiting` (permission): keep this one fixed and clear, it's functional not decorative
- Avoid inside jokes the user hasn't established. Draw from what you know about them.
- No emojis in messages (they don't render well in the speech bubbles).

### Format

The hook command format is:
```
/path/to/openpets-say.sh <state> "message 1" "message 2" "message 3" ...
```

Only replace the quoted message strings. Do not change the script path, the state argument, or the overall hook structure.
