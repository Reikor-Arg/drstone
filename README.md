# Dr. Stone

A [Claude Code](https://claude.com/product/claude-code) plugin that reminds Claude, **on every message**, to keep answers short.

Caveman in form, not in content: fewer words, same technical substance. Code, API names and errors stay verbatim.

## Why it exists

A "be brief" instruction in `CLAUDE.md` works for the first few messages and then fades: it sits at the top of the context, far from what Claude is about to write. Two hours in, you get fifteen lines to say "done".

This plugin puts the rule back **right next to your message**, through a `UserPromptSubmit` hook, every time.

## The math

| | tokens |
|---|---|
| reminder injected | ~22 per message |
| output saved | **80-99%** against an uninstructed answer |

Output tokens cost roughly 5× input tokens, so it pays for itself from the first message.

Where the range comes from: a 2,000-token wall of text where thirty tokens would do is a 98.5% cut. Answers that were already reasonable land nearer 80%. Nothing is lost on the way down — the reminder strips filler, not substance, and the prose stays normal English rather than turning into telegraphic caveman-speak.

## Install

One command. Works in the **terminal**, the **desktop app** and **Claude inside VS Code** — hooks don't depend on the interface.

**Windows** (PowerShell):

```powershell
irm https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.ps1 | iex
```

**macOS / Linux**:

```bash
curl -fsSL https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.sh | sh
```

Then **quit and reopen Claude Code** — the whole app, not just the session: `settings.json` is read when the process starts. If you see `DRSTONE:` above the first answer, it works.

The installer writes a timestamped backup before touching anything and keeps whatever hooks, permissions and plugins you already had. To uninstall: remove the `UserPromptSubmit` block from `~/.claude/settings.json`, or restore the `.bak`.

<details>
<summary>Manual install, if you'd rather not run a script</summary>

### A) Paste the hook (works everywhere, needs nothing)

Open `~/.claude/settings.json` (Windows: `C:\Users\YOUR_USER\.claude\settings.json`) and add the `hooks` block. If you already have one, add the `UserPromptSubmit` key inside it:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo DRSTONE: keep answers short. NEVER: filler, pleasantries, narrating tool calls, unrequested extras. Code and errors verbatim.",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

Save and restart Claude Code. No need to clone this repo.

### B) As a plugin, from the terminal CLI

```
/plugin marketplace add Reikor-Arg/drstone
/plugin install drstone
```

**Heads up:** `/plugin` currently exists only in the terminal CLI. In the desktop app and the VS Code extension it answers `/plugin isn't available in this environment`. Use option A or C there.

### C) As a plugin, editing settings by hand

Same thing `/plugin install` does under the hood. In `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "drstone": { "source": { "source": "github", "repo": "Reikor-Arg/drstone" } }
  },
  "enabledPlugins": {
    "drstone@drstone": true
  }
}
```

</details>

No `/caveman` before every message — which is exactly what makes you spend more.

## Why it isn't a VS Code extension

A VS Code extension can't write into Claude's context: it paints in the editor, and Claude doesn't read the editor. The only channel that reaches the conversation is a hook, and hooks live in plugins.

## The whole prompt

That one line is the entire plugin. No hidden skill, no rule file:

```
DRSTONE: keep answers short. NEVER: filler, pleasantries, narrating tool calls, unrequested extras. Code and errors verbatim.
```

Claude replies in whatever language you write in — the reminder only changes the density.

## What it does not do

- No Node, no runtime: it's an `echo`. Milliseconds, nothing stays resident.
- Sends nothing anywhere.
- Doesn't touch your model or the rest of your settings.

## The name

After [Dr. Stone](https://en.wikipedia.org/wiki/Dr._Stone), where humanity falls back to the stone age and Senku gets by talking like a caveman while reasoning like a scientist. That's the idea: primitive form, intact content.

## License

MIT
