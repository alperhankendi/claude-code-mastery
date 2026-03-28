# Claude Commands

Claude command'lar, tekrarlayan workflow'ları slash command olarak paketlemenizi sağlar. `.claude/commands/` dizininde Markdown dosyaları olarak tanımlanır ve session içinde `/command-adı` ile çağrılır.

## Command Yapısı

```
.claude/commands/
├── deploy.md
├── gh-release.md
├── test-all.md
└── new-feature.md
```

Her command dosyası YAML frontmatter + Markdown talimatlarından oluşur:

```Markdown
---
description: Komutun kısa açıklaması
allowed-tools: Bash(git:*), Read, Edit
---

Komut talimatları burada.
$ARGUMENTS kullanıcının verdiği parametreleri içerir.
```

| Alan            | Açıklama                                     |
| --------------- | -------------------------------------------- |
| `description`   | `/` menüsünde görünen kısa açıklama          |
| `allowed-tools` | Komutun kullanabileceği tool'lar (opsiyonel) |
| `$ARGUMENTS`    | Kullanıcının komuttan sonra yazdığı metin    |

## Pratik Örnek: GitHub Actions Release Trigger

Bu command, GitHub Actions release workflow'unu doğrudan Claude Code'dan tetikler:

**`.claude/commands/gh-release.md`:**

```Markdown
---
description: Trigger GitHub Actions Release workflow (patch/minor/major)
---

Trigger the GitHub Actions Release workflow for this repository.

## Arguments

`$ARGUMENTS` may contain:
- A bump type: `patch`, `minor`, or `major` (default: `patch`)
- Optionally `--prerelease` or `--pre` flag

Parse `$ARGUMENTS`:
- If empty -> bump=patch, prerelease=false
- If contains `major` -> bump=major
- If contains `minor` -> bump=minor
- If contains `--prerelease` or `--pre` -> prerelease=true

## Steps

1. Show the user what will be triggered:
   - bump type, prerelease flag, branch

2. Run:
gh workflow run release.yml \
  --repo MyOrg/my-repo \
  --field bump=<bump> \
  --field prerelease=<true|false>

3. Wait ~3 seconds then get the run URL:
gh run list --workflow=release.yml --repo MyOrg/my-repo --limit=1

4. Show the user the run URL to monitor progress.
```

**Kullanım:**

```
> /gh-release minor
> /gh-release major --prerelease
> /gh-release                      # varsayılan: patch
```

## Diğer Command Örnekleri

**Yeni feature başlatma:**

```Markdown
---
description: Start new feature branch with boilerplate
allowed-tools: Bash(git:*), Read, Edit, Write
---

1. Create branch: git checkout -b feature/$ARGUMENTS
2. Pull latest main
3. Set up boilerplate files
4. Begin implementation
```

**Test ve lint çalıştırma:**

```Markdown
---
description: Run full test suite with coverage
allowed-tools: Bash(npm:*), Read
---

1. Run linter: npm run lint
2. Run type check: npm run typecheck
3. Run tests with coverage: npm test -- --coverage
4. Summarize results
```

**PR oluşturma:**

```Markdown
---
description: Create PR with conventional commit format
allowed-tools: Bash(git:*, gh:*), Read
---

1. Check current branch and diff against main
2. Generate PR title from commits (conventional format)
3. Create PR: gh pr create --title "..." --body "..."
4. Show PR URL
```

## Command vs Skill vs Hook

|               | Command                  | Skill                 | Hook                |
| ------------- | ------------------------ | --------------------- | ------------------- |
| **Tetikleme** | Manuel (`/command`)      | Otomatik (context)    | Otomatik (event)    |
| **Kontrol**   | Siz karar verirsiniz     | Claude karar verir    | Sistem karar verir  |
| **Kullanım**  | Tekrarlayan workflow     | Domain bilgisi        | Deterministik kural |
| **Örnek**     | `/deploy`, `/gh-release` | Güvenlik pattern'ları | Format sonrası lint |

> **Kural:** Zamanlamayı kontrol etmek istiyorsanız command, otomatik uygulanmasını istiyorsanız skill, her zaman çalışmasını istiyorsanız hook kullanın.

