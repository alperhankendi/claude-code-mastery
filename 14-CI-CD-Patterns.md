# CI/CD Patterns

Claude Code'u sadece interaktif geliştirme için değil, CI/CD pipeline'larında otomasyon aracı olarak da kullanabilirsiniz. İki temel yaklaşım var: `claude -p` ile headless mod ve GitHub Actions entegrasyonu.

## Headless Mode: claude -p

`claude -p` (print mode), Claude Code'u non-interactive modda çalıştırır. Hook, LSP ve plugin yüklenmez, stdin'den girdi alır, stdout'a yazar:

```Shell
# Basit kullanım
claude -p "Bu projedeki tüm TODO'ları listele"

# Pipe ile
cat build-error.txt | claude -p "Bu build hatasının kök nedenini kısaca açıkla" > fix.md

# JSON çıktı (CI/CD için)
claude -p --json "package.json'daki outdated dependency'leri listele"
```

**Kullanım senaryoları:**

| Senaryo              | Komut                                                            |
| -------------------- | ---------------------------------------------------------------- |
| Build hatası analizi | `cat error.log \| claude -p "kök nedeni bul"`                    |
| Changelog oluşturma  | `claude -p "son 10 commit'ten changelog üret"`                   |
| PR description       | `claude -p "bu branch'teki değişiklikleri özetle"`               |
| Migration script     | `claude -p "DB schema diff'ten migration üret"`                  |
| Dependency audit     | `claude -p --json "güvenlik açığı olan dependency'leri raporla"` |

## GitHub Actions Entegrasyonu

Anthropic'in resmi GitHub Action'ı ([claude-code-action](https://github.com/anthropics/claude-code-action)), Claude Code'u doğrudan CI/CD pipeline'ında çalıştırır. PR'larda `@claude` ile tetiklenir.

### Hızlı Kurulum

```Shell
# Claude Code terminal'inde:
> /install-github-app
```

Bu komut GitHub App kurulumunu ve gerekli secret'ları adım adım yönlendirir.

### Manuel Kurulum

1. [Claude GitHub App](https://github.com/apps/claude)'u repository'ye kurun
2. `ANTHROPIC_API_KEY`'i repository secret olarak ekleyin
3. Workflow dosyasını `.github/workflows/` altına kopyalayın

### Basic Workflow

`@claude` mention'larına yanıt veren temel workflow:

```YAML
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Otomatik PR Review

Her PR açıldığında otomatik code review:

```YAML
name: Code Review
on:
  pull_request:
    types: [opened, synchronize]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Bu PR'ı kod kalitesi, doğruluk ve güvenlik açısından incele. Diff'i analiz et, bulgularını review comment olarak paylaş."
          claude_args: "--max-turns 5"
```

### Zamanlanmış Rapor

Her gün sabah 9'da commit ve issue özeti:

```YAML
name: Daily Report
on:
  schedule:
    - cron: "0 9 * * *"
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Dünkü commit'leri ve açık issue'ları özetle"
          claude_args: "--model opus"
```

## Action Parametreleri

| Parametre           | Açıklama                                     | Zorunlu |
| ------------------- | -------------------------------------------- | ------- |
| `prompt`            | Claude'a talimat (plain text veya skill adı) | Hayır   |
| `claude_args`       | CLI argümanları                              | Hayır   |
| `anthropic_api_key` | API key                                      | Evet\*  |
| `github_token`      | GitHub API erişimi için token                | Hayır   |
| `trigger_phrase`    | Tetikleme ifadesi (varsayılan: `@claude`)    | Hayır   |
| `use_bedrock`       | AWS Bedrock kullan                           | Hayır   |
| `use_vertex`        | Google Vertex AI kullan                      | Hayır   |

\*Bedrock/Vertex kullanımında gerekli değil

**`claude_args`** **yaygın parametreler:**

```YAML
claude_args: "--max-turns 5 --model claude-sonnet-4-6 --allowedTools Bash,Read,Edit"
```

## @claude Kullanım Örnekleri

Issue veya PR comment'lerinde:

```
@claude implement this feature based on the issue description
@claude fix the TypeError in the user dashboard component
@claude bu endpoint'e authentication ekle
@claude bu PR'daki güvenlik sorunlarını incele
```

## Cloud Provider Entegrasyonu

### AWS Bedrock

```YAML
steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
      aws-region: us-west-2

  - uses: anthropics/claude-code-action@v1
    with:
      use_bedrock: "true"
      claude_args: "--model us.anthropic.claude-sonnet-4-6 --max-turns 10"
```

### Google Vertex AI

```YAML
steps:
  - uses: google-github-actions/auth@v2
    id: auth
    with:
      workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
      service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

  - uses: anthropics/claude-code-action@v1
    with:
      use_vertex: "true"
      claude_args: "--model claude-sonnet-4@20250514 --max-turns 10"
    env:
      ANTHROPIC_VERTEX_PROJECT_ID: ${{ steps.auth.outputs.project_id }}
      CLOUD_ML_REGION: us-east5
```

## Maliyet Optimizasyonu

| Strateji                     | Nasıl                                             |
| ---------------------------- | ------------------------------------------------- |
| `--max-turns` sınırla        | Sonsuz döngüyü önler, varsayılan 10               |
| Workflow timeout ekle        | `timeout-minutes: 15` ile runaway job'ları durdur |
| Concurrency control          | Paralel çalışan job sayısını sınırla              |
| Spesifik `@claude` komutları | Gereksiz API çağrısını azaltır                    |
| Sonnet kullan                | Opus'a göre %40 ucuz, çoğu CI görevi için yeterli |

## CLAUDE.md ile Davranış Özelleştirme

Repository kökündeki `CLAUDE.md`, GitHub Actions'daki Claude'un davranışını da yönlendirir. Code style, review kriterleri ve proje kurallarını buraya yazın:

```Markdown
# PR Review Kuralları
- Her PR'da test olmalı
- Güvenlik açıkları için OWASP Top 10 kontrol et
- Breaking change varsa BREAKING CHANGE label'ı ekle
```

## Troubleshooting

| Problem                                | Çözüm                                                                        |
| -------------------------------------- | ---------------------------------------------------------------------------- |
| Claude `@claude`'a yanıt vermiyor      | GitHub App kurulumunu doğrula, workflow'ların etkin olduğunu kontrol et      |
| Claude'un commit'lerinde CI çalışmıyor | GitHub App kullanın (Actions user değil), workflow trigger'ları kontrol edin |
| Auth hatası                            | API key'in geçerli olduğunu ve secret adlarının doğru olduğunu kontrol edin  |

> **Kaynaklar:**
>
> * [Claude Code GitHub Actions Docs](https://code.claude.com/docs/en/github-actions)
> * [claude-code-action repo](https://github.com/anthropics/claude-code-action)
> * [Workflow örnekleri](https://github.com/anthropics/claude-code-action/tree/main/examples)

