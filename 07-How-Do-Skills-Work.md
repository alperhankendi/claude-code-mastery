# How Do Skills Work?

Skill'ler, Claude Code'un context'e göre otomatik olarak uyguladığı yeniden kullanılabilir alan uzmanlığı paketleridir. Güvenlik pattern'ları, kodlama standartları, mimari prensipler gibi özelleşmiş bilgileri kodlar — Claude bunları istemeden tanır ve uygular.

**Skill vs Slash Command vs Prompt:**

* **Skill** : context'e göre otomatik uygulama, istemeden çalışır
* **Slash Command** :açık çağrı, zamanlamayı siz kontrol edersiniz
* **Prompt** : Claude'un takip edip etmeyeceği bir rehber

> Karar ağacı için bkz. [03-Decision-Framework.md](03-Decision-Framework.md#command-vs-skill-vs-subagent-vs-agent-team)

## Skill Types

| Tip             | Amaç                            | Örnek                                     |
| --------------- | ------------------------------- | ----------------------------------------- |
| **Analysis**    | Code review, debugging, audit   | Güvenlik denetimi, performans analizi     |
| **Generation**  | Template oluşturma, boilerplate | Component scaffold, API endpoint stub     |
| **Refactoring** | Kod dönüşüm pattern'ları        | Callback'lerden async/await'e geçiş       |
| **Testing**     | Test üretimi ve doğrulama       | Unit test scaffold, E2E senaryo           |
| **Domain**      | Özelleşmiş bilgi uygulaması     | React best practices, DevOps pattern'ları |

## Skill Structure

Skill'ler `.claude/skills/` dizininde Markdown dosyaları olarak yaşar. YAML frontmatter ile metadata ve davranış tanımlanır:

```
.claude/skills/
├── security-audit.md
├── performance-analysis.md
├── react-patterns.md
└── custom-domain-rules.md
```

**Temel skill yapısı:**

```Markdown
---
name: performance-analysis
description: Darboğazları tespit et ve optimizasyon öner
type: analysis
tags: [performance, optimization]
---

Performans analizi yaparken şunları değerlendir:
- Algoritma karmaşıklığı (Big O analizi)
- Bellek kullanım pattern'ları
- Gereksiz re-render'lar (React)
- Veritabanı query N+1 problemleri
- Bundle size etkisi

Değişiklik önermeden önce her zaman uygun tool'larla ölç.
```

**Frontmatter alanları:**

| Alan           | Açıklama                                                      |
| -------------- | ------------------------------------------------------------- |
| `name`         | Benzersiz skill tanımlayıcısı                                 |
| `description`  | Tek satırlık yetenek özeti keşif için kritik                  |
| `type`         | Kategori (analysis, generation, refactoring, testing, domain) |
| `version`      | Semantik versiyonlama                                         |
| `tags`         | Aranabilir metadata                                           |
| `hooks`        | Gömülü otomasyon (PreToolUse, PostToolUse, Stop)              |
| `dependencies` | Gerektirdiği diğer skill veya veri                            |
| `models`       | Minimum ve önerilen Claude modelleri                          |

## Skill with Embedded Hooks

Skill'ler doğrudan hook tanımlayabilir skill aktifken otomatik çalışır:

```Markdown
---
name: secure-deployment
description: Guvenlik dogrulamali deployment skill
type: refactoring
hooks:
  PreToolUse:
    - matcher: Bash
      command: ".claude/hooks/validate-deploy.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      command: "npm run security-check"
  Stop:
    - command: ".claude/hooks/cleanup.sh"
      once: true
---

Deployment checklist:
1. Tüm testlerin geçtiğini doğrula
2. Güvenlik taraması çalıştır
3. Environment variable'ları kontrol et
4. SSL sertifikalarını doğrula
```

`once` seçeneği hook'un session başına yalnızca bir kez çalışmasını sağlar.

## Skill Discovery & Progressive Disclosure

Tüm skill'leri önceden yüklemek context bloat yaratır. Progressive disclosure ile Claude, skill'leri context'e göre keşfeder:

1. Session başlangıcında skill'ler taranır
2. Sadece description'lar system context'e eklenir
3. Tam skill içeriği, Claude ilgili olduğuna karar verdiğinde yüklenir
4. MCP Tool Search'e benzer: açıklamalar önce, tam içerik talep üzerine

Yapılandırma:

```JSON
{
  "skillDiscoveryAutoEnable": "auto:10"
}
```

Seçenekler: `true` (her zaman), `false` (tümünü önceden yükle), `auto:N` (skill'ler context'in N%'ini aştığında etkinleştir).

## Environment Variables

| Değişken                | Erişim         | Amaç                                   |
| ----------------------- | -------------- | -------------------------------------- |
| `${CLAUDE_SKILL_DIR}`   | Tüm skill'ler  | Skill'in kendi dizin konumuna referans |
| `${CLAUDE_PROJECT_DIR}` | Hook komutları | Göreceli yollar için proje kökü        |

## Permissions & Scope

Skill'ler aynı permission sistemine tabidir:

* Proje kapsamlı: `.claude/skills/` (git ile paylaşılır)
* Kişisel: `~/.claude/skills/` (tüm projeler)
* Edit/Bash izinlerini atlayamaz.
* MCP erişimi gerektiren skill'ler permission rule'larına ihtiyaç duyar.

## Practical Examples

**Güvenlik analizi skill:**

```Markdown
---
name: security-patterns
description: OWASP ve CWE guvenlik pattern'larini uygula
type: analysis
tags: [security, owasp]
---

Kontrol et:
- SQL injection açıkları
- XSS saldırı vektörleri
- Güvensiz doğrudan nesne referansları
- Eksik input validation
- Hardcoded credential'lar
```

**React best practices skill:**

```Markdown
---
name: react-patterns
description: React component ve hook best practices
type: domain
tags: [react, frontend]
---

Bu pattern'ları uygula:
- Functional component + hook kullan
- Pahalı hesaplamaları memoize et
- Mantık tekrarı için custom hook çıkar
- Prop drilling yerine context kullan
- Event handler'lar için useCallback kullan
```

**TypeScript strict mode skill (hook'lu):**

```Markdown
---
name: typescript-strict-mode
description: TypeScript strict mode linting ve type safety
type: refactoring
version: 2.1.0
tags: [typescript, quality, linting]
hooks:
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "npx tsc --noEmit"
---

TypeScript ile çalışırken:
1. Strict mode etkinleştir: "strict": true (tsconfig.json)
2. Fonksiyonlarda açık return type kullan
3. any tipinden kaçın; generic kullan
4. noImplicitAny ve strictNullChecks etkinleştir
5. Karmaşık tipler için discriminated union kullan
6. Type guard ve type predicate kullan

Her dosya düzenlemesi tsc --noEmit'i hatasız geçmeli.
```

## Skill Management Commands

```Shell
claude skill list                    # Tüm mevcut skill'leri listele
claude skill create my-skill         # İnteraktif skill oluşturma sihirbazı
claude skill remove security-audit   # Skill sil
claude skill test react-patterns     # Skill aktivasyonu ve kalitesini test et
```

## Best Practices

| Kural                         | Açıklama                                              |
| ----------------------------- | ----------------------------------------------------- |
| **Odaklı tut**                | Her skill tek bir domain (güvenlik, performans, stil) |
| **Uygulama için hook kullan** | Claude'un kuralları hatırlamasına güvenme; hook'la    |
| **Versiyonla**                | Semantik versiyonlama ile değişiklikleri takip et     |
| **Gereksinimleri belgele**    | Frontmatter'da minimum model seviyesini belirt        |
| **Bağımlılıkları bildir**     | Skill'in gerektirdiği diğer skill/veri'yi deklare et  |
| **Bağımsız tut**              | Skill'ler harici context olmadan çalışmalı            |
| **Keşfi test et**             | Skill'lerin beklendiğinde aktifleştiğini doğrula      |

## When to Create a Skill

**Skill oluştur:**
- Alan uzmanlığı otomatik aktifleşmeli
- Birden fazla takım üyesi aynı bilgiye ihtiyaç duyuyor
- Aynı pattern'ları veya kuralları tekrar tekrar açıklıyorsun
- Context, açık çağrı olmadan enjekte edilmeli
- Bilgi birden fazla dosyayı kapsıyor ve organizasyon gerekiyor

**Skill oluşturma:**
- Çağrı zamanlamasını kontrol etmek istiyorsan (slash command kullan)
- Görev ayrı context gerektiriyorsa (subagent kullan)
- Tek seferlik bir prompt'sa (direkt yaz)
- "Skill" aslında tek bir template'se (slash command kullan)

> **Expert tip:** Kendinizi auth kodu üzerinde çalışırken her seferinde `/security-review` yazarken buluyorsanız, bunu skill'e dönüştürün. Uzmanlığı ambient yapın, açıkça çağrılır değil. Açık çağrı istiyorsanız command olarak tutun.

## Team Sharing Strategies

**Git ile paylaşım (proje skill'leri için önerilen):**

```Shell
# Skill'i projeye ekle
mkdir -p .claude/skills/team-standard
# SKILL.md ve destekleyici dosyaları oluştur

# Commit'le
git add .claude/skills/
git commit -m "Add team coding standards skill"
git push

# Takım arkadaşları otomatik alır
git pull
claude  # Skill artık kullanılabilir
```

**Symlink ile projeler arası paylaşım:**

```Shell
# Merkezi skill konumu oluştur
mkdir -p ~/shared-skills/security-reviewer
# SKILL.md oluştur

# Projelere symlink'le
ln -s ~/shared-skills/security-reviewer ~/.claude/skills/security-reviewer
# Artık tüm projelerinizde kullanılabilir
```

**Plugin olarak dağıtım:** Daha geniş dağıtım için skill'leri plugin'e paketle:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── my-skill/
        └── SKILL.md
```

## Plugin vs Skill

Bu iki kavram sık karıştırılır:

|              | Skill                                  | Plugin                                            |
| ------------ | -------------------------------------- | ------------------------------------------------- |
| **Ne**       | Tek bir markdown dosyası (.md)         | Skill + MCP + Hook + Command paketleyen bundle    |
| **Konum**    | `.claude/skills/my-skill.md`           | `.claude/plugins/my-plugin/plugin.json`           |
| **Kapsam**   | Tek bir alan uzmanlığı                 | Tam bir araç seti                                 |
| **Kurulum**  | Dosyayı dizine koy                     | `/plugin marketplace add ...`                     |
| **İçerik**   | YAML frontmatter + markdown talimatlar | Manifest + birden fazla skill, hook, MCP, command |
| **Paylaşım** | Git ile commit'le                      | Plugin marketplace veya GitHub repo               |

**Kısacası: Skill tek bir bilgi kartıdır, Plugin ise birden fazla skill'i, hook'u ve MCP server'ı bir arada sunan kurulabilir pakettir.**

Örnek: `chrome-devtools-mcp` bir **plugin**'dir, içinde MCP server (Chrome bağlantısı), skill'ler (debugging rehberi) ve hook'lar (otomatik screenshot) barındırır. `effective-go` ise bir **skill**'dir sadece Go best practices içeren tek bir markdown dosyası.

## Sık Kullandığım Skill'ler

| Skill                     | Komut                                      | Ne Yapar                                                                                                                                                                             |
| ------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Chrome DevTools**       | `ChromeDevTools/chrome-devtools-mcp`       | Chrome'u canlı kontrol et: screenshot, console log, network analiz, Core Web Vitals. 29 tool, Puppeteer + CDP. Kurulum: `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp` |
| **CLAUDE.md İyileştirme** | `/claude-md-management:claude-md-improver` | Tüm CLAUDE.md dosyalarını tarar, kalite raporu çıkarır, iyileştirme uygular. Geliştirme sonrası günlük olarak claude.md dosyasını yenilemek ve sadeleştirmek faydalı                 |
| **CLAUDE.md Revizyonu**   | `/claude-md-management:revise-claude-md`   | Session sonunda öğrenilenleri analiz edip CLAUDE.md'ye yazar                                                                                                                         |
| **Effective Go**          | `/effective-go`                            | golang.org/doc/effective\_go best practices: errors as values, interface composition, naming conventions, concurrency pattern'ları                                                   |
| **Frontend Design**       | `/frontend-design`                         | Production-grade UI component/sayfa oluşturur, generic AI estetiğinden kaçınır                                                                                                       |
| **Go LSP (gopls)**        | `/plugin marketplace add gopls-lsp`        | Resmi Go language server code navigation, diagnostics, completion, refactoring. Go projelerinde Claude'un kod anlama kalitesini önemli ölçüde artırır                                |
| **Playground**            | `/playground`                              | Tek dosyalık interaktif HTML playground oluşturur — kontroller, live preview, kopyalanabilir çıktı                                                                                   |
| **Simplify**              | `/simplify`                                | Değiştirilen kodu gözden geçirir — tekrar eden kod, gereksiz soyutlama, aşırı mühendislik tespit eder ve düzeltir                                                                    |
| **Superpowers**           | `/superpowers`                             | Yapılandırılmış lifecycle planning: brainstorm → plan → TDD → implement → debug → review. Karmaşık feature geliştirmede çok faydalı                                                  |

## Popüler Community Skill & Plugin'ler

| Skill/Plugin     | Kurulum | Ne Yapar                                                                                                                                                     | Kurulum Komutu                         |
| ---------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------- |
| **feature-dev**  | 89K+    | 7 fazlı workflow: requirements → explore → design → implement → test → review → docs. Tek prompt ile feature çıkarır                                         | `/plugin marketplace add feature-dev`  |
| **batch**        | —       | İşi 5-30 bağımsız birime böler, her biri izole git worktree'de paralel çalışır, otomatik PR oluşturur. Büyük refactoring'lerin vazgeçilmezi                  | `/plugin marketplace add batch`        |
| **code-review**  | —       | Anthropic resmi plugin. Diff bazlı code review, güvenlik ve kalite kontrolleri. Ücretsiz, plan kısıtlaması yok                                               | `/plugin marketplace add code-review`  |
| **context7**     | —       | Upstash tarafından geliştirildi. Claude'un training data'sına güvenmek yerine güncel, versiyon-spesifik kütüphane dokümantasyonunu doğrudan session'a akıtır | `/plugin marketplace add context7`     |
| **local-review** | —       | Paralel yerel diff code review. Birden fazla dosyadaki değişiklikleri eş zamanlı inceler, her diff için ayrı subagent çalıştırır                             | `/plugin marketplace add local-review` |

### Superpowers

Superpowers, Claude Code session'larına yapılandırılmış bir geliştirme lifecycle'ı ekler. Tek bir plugin ile birden fazla faz kapsar:

| Faz            | Ne Yapar                                                                |
| -------------- | ----------------------------------------------------------------------- |
| **Brainstorm** | Problemi farklı açılardan analiz eder, alternatif yaklaşımları tartışır |
| **Plan**       | Mimari kararlar, dosya yapısı, bağımlılıklar, risk analizi              |
| **TDD**        | Red-Green-Refactor döngüsü ile test-driven development                  |
| **Implement**  | Plan'a uygun implementation, her adımda test doğrulaması                |
| **Debug**      | Sistematik hata ayıklama reproduce → isolate → fix → verify             |
| **Review**     | Kod kalitesi, güvenlik, performans ve maintainability incelemesi        |

**Ne zaman kullanmalı:** Karmaşık, çok adımlı görevlerde Claude'un yapılandırılmış bir süreç izlemesini istediğinizde. Özellikle yeni bir feature'ın sıfırdan tasarlanıp geliştirilmesinde faydalı.

**Ne zaman gereksiz:** Basit bug fix, tek dosya düzenleme veya hızlı soru-cevap. Bu durumda overhead yaratır.

> **Kaynaklar:**
>
> * [TurboDocx — Best Plugins 2026](https://www.turbodocx.com/blog/best-claude-code-skills-plugins-mcp-servers)
> * [Composio — Top 10 Skills](https://composio.dev/content/top-claude-skills)
> * [Firecrawl — Top 10 Plugins](https://www.firecrawl.dev/blog/best-claude-code-plugins)

## Awesome Claude Code-GitHub Koleksiyonları

| Repo                                                                                   | Açıklama                                                                         |
| -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| [awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | En kapsamlı: 135 agent, 35 skill, 42 command, 150+ plugin, 19 hook, 8 MCP config |
| [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)             | Skill, hook, slash-command, agent orchestrator ve plugin küratörlü listesi       |
| [awesome-claude-code](https://github.com/jqueryscript/awesome-claude-code)             | Tool, IDE entegrasyon, framework ve geliştirici kaynakları                       |
| [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)           | Composio tarafından skill, kaynak ve workflow araçları                           |
| [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills)             | Claude Code odaklı skill ve kaynak koleksiyonu                                   |
| [awesome-claude-plugins](https://github.com/quemsah/awesome-claude-plugins)            | 8.600+ repo indeksli otomatik plugin adoption metrikleri                         |

