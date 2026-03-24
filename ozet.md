# Claude Code Workflow Cheatsheet

## 1. Understanding CLAUDE.md

**CLAUDE.md** = Claude's persistent memory about your project. Loaded automatically at the start of every session.

| WHAT          | WHY                    | HOW              |
| ------------- | ---------------------- | ---------------- |
| Tech stack    | Purpose of each module | Build/test       |
| Directory map | Design decisions       | `/lint` commands |
| Architecture  |                        | Workflows        |
|               |                        | Gotchas          |

### Example

```Shell
# Project: MyApp
FastAPI REST API + React SPA + Postgres

## Commands
npm run dev
npm run test
npm run lint

## Architecture
/app → Next.js App Router pages
/lib → shared utilities
/prisma → DB schema & migrations
```

***

## 2. Memory File Hierarchy

```
~/.claude/CLAUDE.md          ← Global — all projects
~/CLAUDE.md                  ← Parent — monorepo root
./CLAUDE.md                  ← Project — shared on git
./frontend/CLAUDE.md         ← Subfolder — scoped context
```

**Rules:**

* Keep each < 200 lines
* Subfolder files append context
* Never overwrite parent context

***

## 3. CLAUDE.md Best Practices

1. Run `/init` first then refine output
2. Be specific in instructions
3. Add gotchas Claude cannot infer
4. Reference docs with `@filename`
5. Add workflow rules
6. Keep memory concise
7. Commit to Git for team sharing

***

## 4. Project File Structure

```
your_project/
├── CLAUDE.md
├── .claude/
│   ├── settings.json
│   ├── settings.local.json
│   ├── skills/
│   │   ├── code-review/
│   │   │   └── SKILL.md
│   │   ├── testing/
│   │   │   └── SKILL.md
│   │   └── helpers.py
│   ├── commands/
│   │   └── deploy.md
│   └── agents/
│       └── security-reviewer.md
├── .arc
└── .gitignore
```

***

## 5. Adding Skills (The Superpower)

**Skills** = markdown guides Claude auto-invokes via natural language.

| Type           | Location                           |
| -------------- | ---------------------------------- |
| Project skill  | `.claude/skills/<name>/SKILL.md`   |
| Personal skill | `~/.claude/skills/<name>/SKILL.md` |

> **Description field is critical for auto-activation.**

### Example Skill

```YAML
---
name: testing patterns
description: Jest testing patterns
allowed tools: Read, Grep, Glob
---
```

```Markdown
# Testing Patterns
Use describe + it + AAA pattern
Use factory mocks
```

***

## 6. Skill Ideas for AI Engineers

* Code-review
* Testing patterns
* Commit messages
* Docker-deploy
* Codebase-visualizer
* API-design

***

## 7. Setting Up Hooks

**Hooks** = deterministic callbacks

| PreToolUse | PostToolUse | Notification |
| ---------- | ----------- | ------------ |
|            |             |              |

### Example Hook Configuration

```JSON
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "scripts/sec.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

**Exit codes:** `0` → allow | `2` → block

***

## 8. Permissions & Safety

```JSON
{
  "permissions": {
    "allow": [
      "Read:*",
      "Bash:git:*",
      "Write:*:*.md"
    ],
    "deny": [
      "Read:env:*",
      "Bash:sudo:*"
    ]
  }
}
```

***

## 9. The 4-Layer Architecture

| Layer              | Description                      |
| ------------------ | -------------------------------- |
| **L1 — CLAUDE.md** | Persistent context and rules     |
| **L2 — Skills**    | Auto-invoked knowledge packs     |
| **L3 — Hooks**     | Safety gates and automation      |
| **L4 — Agents**    | Subagents with their own context |

***

## 10. Daily Workflow Pattern

```
cd project && claude
```

1. **Shift + Tab + Tab** → Plan Mode
2. **Describe feature intent**
3. **Shift + Tab** → Auto Accept
4. `/compact`
5. **Esc Esc** → rewind
6. **Commit frequently**
7. **Start new session per feature**

***

## 11. Quick Reference

| Shortcut / Command | Action                   |
| ------------------ | ------------------------ |
| `/init`            | Generate CLAUDE.md       |
| `/doccat`          | Check installation       |
| `/compact`         | Compress context         |
| `Shift + Tab`      | Change modes             |
| `Tab`              | Toggle extended thinking |
| `Esc Esc`          | Rewind menu              |

