# Notes Repo - Claude Code Guides & Reference

## Overview

Documentation and reference notes about Claude Code features (hooks, MCP, model selection, workflows).
This is a content-only repo - no build system, no tests, no application code.

## Structure

* `01-14*.md`, `99*.md` - Numbered guide articles (Turkish, technical terms in English)
* `hooks.json`, `inject-context.sh` - Example hook configurations
* `.claude/hooks/` - Project hook scripts
* `_config.yml`, `_layouts/`, `_includes/`, `assets/` - GitHub Pages site (Jekyll + Cayman dark theme)
* `img/` - Screenshots and images

## Conventions

* Articles are numbered with zero-padded prefixes (`01-`, `02-`, etc.)
* Filenames use hyphens, no special characters (e.g. `02-Which-Model-Should-I-Choose.md`)
* Text in Turkish, headings in English, technical terms stay English (hook, subagent, context bloat, fast mode etc.)
* No emoji in content or Mermaid diagrams
* No em dash characters
* Diagrams: always Mermaid (no ASCII art, no HTML)
* When adding new articles: update README.md table, `_includes/nav.html`, and `_includes/page-nav.html`

## Git & GitHub
* Remote: https://github.com/alperhankendi/claude-code-mastery
* GitHub account for `d:\workspace`: `alperhankendi` (not devcloudvisiontr)
* GPG signing may timeout - if commit fails, retry
* Always ask before pushing
* Site: https://alperhankendi.github.io/claude-code-mastery/

## GitHub Pages
* Jekyll + Cayman theme (dark mode override in `assets/css/style.scss`)
* Mermaid support via `_includes/head-custom.html`
* Search via lunr.js (client-side, `search.json`)
* Sidebar nav: `_includes/nav.html`
* Prev/next: `_includes/page-nav.html`

## Commands

```bash
# Local development
bundle exec jekyll serve          # http://localhost:4000
bundle exec jekyll serve --drafts # Include draft posts

# Deploy: push to master → GitHub Pages auto-deploys
git push origin master
```

## Adding a New Article

1. Create `XX-Title-Here.md` (zero-padded number, hyphenated)
2. Update `README.md` table
3. Update `_includes/nav.html` (sidebar link)
4. Update `_includes/page-nav.html` (prev/next navigation)

## TODO
* [ ] LICENSE (MIT)
* [ ] GitHub repo topics

