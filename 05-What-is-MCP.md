# What is MCP (Model Context Protocol)?

MCP, Claude Code'u harici tool'lara, veritabanlarına, API'lere ve servislere standart bir protokol üzerinden bağlayarak yeteneklerini genişletir.&#x20;

**MCP olmadan** Claude Code dosya okuma ve bash çalıştırma ile sınırlıdır. **MCP ile** production veritabanlarını sorgulayabilir, ticket oluşturabilir, pull request inceleyebilir, error monitoring sistemlerini kontrol edebilir ve organizasyonunuzun kullandığı neredeyse tüm API'lerle doğal dil üzerinden etkileşim kurabilir.

```mermaid
graph LR
    CC["🧠 Claude Code"] --> MCP{"🔌 MCP Protocol"}
    MCP --> GH["GitHub<br/>PR, Issue, CI/CD"]
    MCP --> DB["PostgreSQL<br/>Query, Schema"]
    MCP --> SENTRY["Sentry<br/>Error, Trace"]
    MCP --> LINEAR["Linear<br/>Issue, Sprint"]
    MCP --> MORE["3000+<br/>Server"]

    style CC fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
    style MCP fill:#1a1a3e,stroke:#a855f7,stroke-width:2px,color:#c084fc
    style GH fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style DB fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style SENTRY fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style LINEAR fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style MORE fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
```

## Three Transport Types

```mermaid
graph TD
    TRANSPORT{"Transport Tipi?"} --> HTTP["🌐 HTTP<br/>Remote server'lar<br/>için önerilen"]
    TRANSPORT --> SSE["📡 SSE<br/>Deprecated ama<br/>hâlâ çalışır"]
    TRANSPORT --> STDIO["💻 Stdio<br/>Yerel server'lar"]

    style HTTP fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style SSE fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
    style STDIO fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
```

**HTTP** (remote server'lar için önerilen):

```Shell
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
claude mcp add --transport http api https://api.example.com/mcp \
  --header "Authorization: Bearer $API_TOKEN"
```

**SSE** (deprecated ama fonksiyonel):

```Shell
claude mcp add --transport sse asana https://mcp.asana.com/sse \
  --header "X-API-Key: your-key"
```

**Stdio** (yerel server'lar):

```Shell
claude mcp add --transport stdio postgres \
  --env "DATABASE_URL=postgresql://user:pass@localhost/db" \
  -- npx -y @anthropic-ai/mcp-server-postgres
```

> Windows'ta cmd wrapper gerekir: `cmd /c npx -y @some/package`

## Scope Management

Üç kapsam seviyesi - local, project ve user. Local diğerlerini geçersiz kılar:

| Scope   | Depolama                      | Görünürlük                | Kullanım                  |
| ------- | ----------------------------- | ------------------------- | ------------------------- |
| Local   | `~/.claude.json` (proje yolu) | Tek proje                 | Kişisel API key'ler       |
| Project | `.mcp.json`                   | Takım (versiyon kontrolü) | Paylaşılan entegrasyonlar |
| User    | `~/.claude.json` (root)       | Tüm projeler              | Kişisel tool'lar          |

```Shell
claude mcp add --scope project --transport http github https://...
claude mcp add --scope user --transport stdio personal-tool -- ./my-tool
```

## Configuration - .mcp.json

Proje seviyesi server'ları `.mcp.json` dosyasında tanımlayın:

```JSON
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "database": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp",
      "headers": {
        "Authorization": "Bearer ${SENTRY_API_KEY}"
      }
    }
  }
}
```

Environment variable'lar `${VAR}` syntax'ı ile genişletilir, opsiyonel default destekler: `${VAR:-default}`.

## MCP Tool Search

Server'lar 50+ tool sunduğunda, tool açıklamaları aşırı context tüketir. MCP Tool Search, açıklamaları yalnızca gerektiğinde dinamik olarak yükler:

| Metrik                | Öncesi | Sonrası |
| --------------------- | ------ | ------- |
| Opus 4 doğruluk       | %49    | %74     |
| Opus 4.5 doğruluk     | %79.5  | %88.1   |
| Token overhead azalma | -      | %85     |

Yapılandırma:

```JSON
{
  "mcpToolSearchAutoEnable": "auto:15"
}
```

Seçenekler: `true` (her zaman), `false` (tümünü önceden yükle), `auto:N` (tool'lar context'in N%'ini aştığında etkinleştir).

## MCP Elicitation (v2.1.76+)

MCP server'lar görev sırasında interaktif dialoglar ile yapılandırılmış input isteyebilir. İki hook event destekler:

* **Elicitation** - dialog görünmeden önce
* **ElicitationResult** - kullanıcı yanıtladıktan sonra

Enterprise workflow'larda MCP server prompt'larının politikaya göre önceden doldurulması veya kısıtlanması için kullanılır.

## Management Commands

```Shell
claude mcp add                       # Adım adım interaktif kurulum
claude mcp list                      # Tüm server'ları listele
claude mcp get github                # Belirli server detayları
claude mcp remove github             # Server kaldır
claude mcp reset-project-choices     # Proje onaylarını sıfırla
claude mcp add-from-claude-desktop   # Claude Desktop'tan içe aktar
```

Session içinde:

```
> /mcp                               # İnteraktif MCP yönetimi
```

## OAuth Authentication

OAuth gerektiren server'larda tarayıcı otomatik açılır, token'lar güvenli şekilde saklanır ve otomatik yenilenir.

## Using MCP Resources and Prompts

Resource'lara doğrudan referans verin:

```
@github:issue://123
@postgres:schema://users
@docs:file://api/authentication
```

MCP prompt'ları slash command olur:

```
/mcp__github__list_prs
/mcp__github__pr_review 456
/mcp__jira__create_issue "Bug title" high
```

## Output Limits

MCP çıktısı context overflow'u önlemek için sınırlandırılır:

* Uyarı eşiği: 10.000 token
* Varsayılan maksimum: 25.000 token

Gerekirse artırın:

```Shell
export MAX_MCP_OUTPUT_TOKENS=50000
```

## Popular MCP Servers

| Server             | Amaç                | Temel Yetenekler                      |
| ------------------ | ------------------- | ------------------------------------- |
| **GitHub**         | Repository yönetimi | PR, issue, CI/CD, code review         |
| **PostgreSQL**     | Veritabanı erişimi  | Query, schema inceleme, analiz        |
| **Sentry**         | Error monitoring    | Hata arama, stack trace, korelasyon   |
| **Linear**         | Proje yönetimi      | Issue, project, sprint                |
| **Jira/Atlassian** | Enterprise PM       | Ticket, board, workflow               |
| **Playwright**     | Web otomasyon       | E2E test, accessibility tree          |
| **Stripe**         | Ödeme               | İşlem arama, müşteri verisi           |
| **Cloudflare**     | Altyapı             | DNS, worker, analytics                |
| **Supabase**       | Backend-as-service  | Veritabanı, auth, storage             |
| **Figma Dev Mode** | Design-to-code      | Layer hiyerarşisi, auto-layout, token |

## Practical MCP Patterns

**GitHub workflow:**

```
> Review PR #456
> List all open issues assigned to me
> Create a bug issue for the authentication failure we found
```

**Database query'leri:**

```
> What's our total revenue this quarter?
> Show the schema for the users table
> Find customers with no purchases in 90 days
```

**Error monitoring:**

```
> What errors occurred in production today?
> Show the stack trace for error ABC123
> Which deployment introduced these errors?
```

## Enterprise MCP Configuration

Sistem yöneticileri MCP politikalarını `managed-mcp.json` ile uygular:

```JSON
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "sentry" },
    { "serverCommand": ["npx", "-y", "@approved/server"] }
  ],
  "deniedMcpServers": [
    { "serverName": "dangerous-server" }
  ]
}
```

Konumlar:

* **macOS:** `/Library/Application Support/ClaudeCode/managed-mcp.json`
* **Linux:** `/etc/claude-code/managed-mcp.json`
* **Windows:** `C:\ProgramData\ClaudeCode\managed-mcp.json`

Deny listesi mutlak önceliğe sahiptir ve komutlar argüman sırası dahil tam eşleşmelidir.

## claude.ai MCP Connectors (v2.1.46+)

Claude Code, claude.ai hesabınızda yapılandırılmış MCP connector'larını kullanabilir - web ve CLI arasında köprü kurar. Devre dışı bırakmak için:

```Shell
ENABLE_CLAUDEAI_MCP_SERVERS=false
```

## MCP Apps (Ocak 2026)

Anthropic, MCP Apps'i başlattı - MCP server'lar artık Claude içinde render edilen interaktif arayüzler sunabiliyor. Asana, Figma, Slack gibi servisler için arayüzden çıkmadan içerik görüntüleme ve düzenleme mümkün.

***

## Pratik Kullanım: Pencil.dev ile UX Design

> Kişisel pratiğim: Claude Code + Pencil MCP ile doğal dil üzerinden UI tasarımı yapıyorum. Tasarım context'i doğrudan kod üretimine akar, bilgi kaybı sıfır.

[Pencil.dev](https://pencil.dev), Claude Code'a MCP üzerinden bağlanan bir AI-native design tool'dur. `.pen` dosyaları üzerinde çalışır ve doğal dil ile ekran tasarımı oluşturmanızı, iterasyon yapmanızı ve production-ready CSS/HTML üretmenizi sağlar.

**Kurulum:**

```Shell
# Pencil MCP otomatik olarak Claude Code plugin olarak yüklenir
/plugin marketplace add pencil
```

**Workflow:**

```mermaid
graph LR
    PROMPT["💬 Doğal dil<br/>'Login sayfası tasarla'"] --> PENCIL["🎨 Pencil MCP<br/>.pen dosyası oluştur"]
    PENCIL --> REVIEW["👁️ Screenshot<br/>ile doğrula"]
    REVIEW --> ITERATE["🔄 İtere et<br/>'Butonu büyüt'"]
    ITERATE --> PENCIL
    REVIEW --> CODE["💻 CSS/HTML<br/>production code"]

    style PROMPT fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
    style PENCIL fill:#1a1a3e,stroke:#a855f7,stroke-width:2px,color:#c084fc
    style CODE fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
```

**Örnek session:**

```
> Login sayfası tasarla - email, password, "Giriş Yap" butonu, "Şifremi Unuttum" linki
> Screenshot al, kontrol edeyim
> Butonu daha belirgin yap, rengi mavi olsun
> Bu tasarımı React component'ine çevir
```

**Temel Pencil MCP tool'ları:**

| Tool               | Amaç                                   |
| ------------------ | -------------------------------------- |
| `get_editor_state` | Aktif `.pen` dosyasını ve seçimi öğren |
| `batch_design`     | Insert, update, delete, copy işlemleri |
| `get_screenshot`   | Tasarımı görsel olarak doğrula         |
| `get_style_guide`  | Stil rehberi al, tutarlı tasarım yap   |
| `snapshot_layout`  | Layout yapısını incele                 |

> **Kaynak:** [Pencil.dev + Claude Code Workflow](https://atalupadhyay.wordpress.com/2026/02/25/pencil-dev-claude-code-workflow-from-design-to-production-code-in-minutes/) · [DevelopersIO - Pencil MCP](https://dev.classmethod.jp/en/articles/claude-code-pencil-mcp-web-design/)

### Multi-Agent Dashboard Geliştirme - Fully Autonomous Workflow

> Kişisel pratiğim: Veritabanından dashboard'a kadar tüm geliştirme sürecini multi-agent orchestration ile fully autonomous şekilde gerçekleştiriyorum. Her subagent kendi alanında uzmanlaşır, çıktısını bir sonrakine aktarır.

Aşağıdaki akış, bir kullanıcı dashboard'u için veri analizinden production code'a kadar tüm süreci 4 subagent ile otonom olarak yürütür:

```mermaid
graph TD
    START["🎯 Görev: Dashboard Geliştir"] --> DA

    subgraph DA["📊 1. Data Analysis Subagent"]
        DA1["DB'ye bağlan<br/>MCP PostgreSQL"] --> DA2["Tabloları incele<br/>schema, ilişkiler"]
        DA2 --> DA3["Veri analizi yap<br/>metrikler, trendler"]
        DA3 --> DA4["Dashboard'da gösterilecek<br/>verileri belirle"]
    end

    DA --> UX

    subgraph UX["🎨 2. UX Design Subagent"]
        UX1["Analiz çıktılarını al"] --> UX2["@pencil ile<br/>dashboard tasarla"]
        UX2 --> UX3["Screenshot ile<br/>doğrula"]
        UX3 --> UX4["Component spec<br/>ve layout çıkar"]
    end

    UX --> BE

    subgraph BE["⚙️ 3. Backend REST API Subagent"]
        BE1["Veri gereksinimlerini al"] --> BE2["REST API<br/>endpoint tasarla"]
        BE2 --> BE3["Controller, service,<br/>repository katmanları"]
        BE3 --> BE4["API test yaz<br/>ve doğrula"]
    end

    UX --> FE
    BE --> FE

    subgraph FE["💻 4. Frontend Subagent"]
        FE1["Tasarım spec +<br/>API contract al"] --> FE2["React component'leri<br/>oluştur"]
        FE2 --> FE3["API entegrasyonu<br/>yap"]
        FE3 --> FE4["E2E test<br/>ve doğrulama"]
    end

    FE --> DONE["✅ Production-Ready<br/>Dashboard"]

    style DA fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style UX fill:#1a1a3e,stroke:#a855f7,stroke-width:2px,color:#c084fc
    style BE fill:#0f2027,stroke:#3b82f6,stroke-width:2px,color:#60a5fa
    style FE fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
```

**Başlatma prompt'u:**

```
Kullanıcı dashboard'u geliştirmemiz gerekiyor. Aşağıdaki adımları sırasıyla
multi-agent olarak gerçekleştir:

1. DATA ANALYSIS: PostgreSQL MCP ile veritabanına bağlan, tabloları incele,
   veri analizi yap ve dashboard'da gösterilmesi gereken metrikleri belirle.
   Çıktı: veri sözlüğü, metrik listesi, query örnekleri.

2. UX DESIGN: Data analysis çıktılarını kullanarak @pencil ile dashboard
   tasarımını oluştur. Her widget için layout, renk ve tipografi belirle.
   Screenshot ile doğrula. Çıktı: .pen dosyası, component spec.

3. BACKEND REST API: Veri gereksinimleri ve dashboard spec'ine göre REST API
   endpoint'lerini tasarla ve geliştir. Controller → Service → Repository
   katmanlı mimari kullan. Çıktı: API endpoint'leri, contract, testler.

4. FRONTEND: UX tasarım spec'i ve API contract'ını kullanarak React
   component'lerini oluştur, API entegrasyonunu yap, test et.

Her subagent çıktısını bir sonrakine aktarsın. Kararları paylaşarak ilerlesin.
```

**Subagent konfigürasyonu:**

| Subagent      | Model     | Kullandığı MCP/Tool    | Çıktı                                    |
| ------------- | --------- | ---------------------- | ---------------------------------------- |
| Data Analysis | Opus (1M) | PostgreSQL MCP, Bash   | Veri sözlüğü, metrikler, SQL query'ler   |
| UX Design     | Opus      | Pencil MCP             | .pen dosyası, component spec, screenshot |
| Backend API   | Sonnet    | Read, Edit, Bash, Grep | REST endpoint'ler, test'ler              |
| Frontend      | Sonnet    | Read, Edit, Bash       | React component'ler, API entegrasyonu    |

**Neden bu akış çalışıyor:**

* **Sıralı bağımlılık**: Her subagent, öncekinin çıktısını input olarak alır - bilgi kaybı yok
* **İzole context**: Her subagent kendi alanına odaklanır, context bloat olmaz
* **Doğrulama noktaları**: Her aşamada screenshot, test veya spec ile doğrulama yapılır
* **Opus planlama, Sonnet uygulama**: Data analysis ve UX design karmaşık muhakeme gerektirir (Opus), implementation Sonnet ile hızlı ve verimli

> **Önemli:** Bu akış `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` environment variable'ı ile agent teams etkinleştirildiğinde en verimli çalışır. Alternatif olarak sıralı subagent'lar olarak da çalıştırılabilir.

***

## Pratik Kullanım: Chrome DevTools MCP ile Remote Debug

> Kişisel pratiğim: Chrome DevTools MCP ile Claude Code'a canlı tarayıcıyı kontrol ettiriyorum, console log'ları, network request'leri, screenshot ve performance analizi doğrudan agent context'ine akıyor.

[Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp), Claude Code'a Chrome DevTools Protocol üzerinden canlı bir Chrome tarayıcıya tam erişim sağlar.

**Ne yapabilir:**

* Tarayıcıyı kontrol et (tıkla, form doldur, navigate et)
* Herhangi bir viewport boyutunda screenshot al
* Tüm network request/response'ları izle
* Console log'larını gerçek zamanlı oku
* Core Web Vitals ölç

**Kurulum:**

```Shell
# Chrome'u remote debugging ile başlat
chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug

# MCP server'ı ekle
claude mcp add --transport stdio chrome-devtools \
  -- npx -y chrome-devtools-mcp --browserUrl http://localhost:9222
```

> `--user-data-dir` Chrome 136+ için zorunlu - login session'ları, cookie'ler ve profil verileri bu dizinde saklanır, yeniden başlatmalarda korunur.

**Workflow:**

```mermaid
graph LR
    CLAUDE["🧠 Claude Code"] --> CDP["🔧 Chrome DevTools<br/>MCP Server"]
    CDP --> CHROME["🌐 Chrome<br/>:9222"]
    CHROME --> CONSOLE["📋 Console Logs"]
    CHROME --> NETWORK["🔗 Network"]
    CHROME --> SCREENSHOT["📸 Screenshot"]
    CHROME --> PERF["⚡ Performance"]

    style CLAUDE fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
    style CDP fill:#1a1a3e,stroke:#a855f7,stroke-width:1px,color:#c084fc
    style CHROME fill:#0f2027,stroke:#3b82f6,stroke-width:2px,color:#60a5fa
```

**Örnek session:**

```
> localhost:3000'i aç ve screenshot al
> Login formunu doldur - email: test@test.com, password: 123456
> Console'da hata var mı kontrol et
> Network tab'da hangi API çağrıları yapılıyor listele
> Sayfanın Core Web Vitals skorunu ölç
```

**Authenticated session'lar için:** `--user-data-dir` ile bir kez login olun, session cookie'leri browser restart'larında bile korunur - her seferinde tekrar login gerekmez.

> **Kaynak:** [Chrome DevTools MCP - GitHub](https://github.com/ChromeDevTools/chrome-devtools-mcp) · [Authenticated Websites Guide](https://raf.dev/blog/chrome-debugging-profile-mcp/) · [Resmi Docs](https://code.claude.com/docs/en/chrome)

***

