# Decision Frameworks

Özellikleri bilmek yetmez. Her birini ne zaman kullanacağınızı bilmeniz gerekir. Bu karar ağaçları bilgiyi eyleme dönüştürür.

## Which Model Should I Use?

```mermaid
graph TD
    START["Görev nedir?"] --> SIMPLE{"Basit mi?<br/><small>dosya arama, hızlı soru, formatlama</small>"}
    SIMPLE -- "Evet" --> HAIKU["Haiku<br/>~$0.03/görev<br/>En hızlı"]
    SIMPLE -- "Hayır" --> DEEP{"Derin muhakeme<br/>gerekiyor mu?<br/><small>mimari, debug, güvenlik</small>"}
    DEEP -- "Evet" --> OPUS["Opus 4.6<br/>~$2.00/görev<br/>1M context, adaptive thinking"]
    DEEP -- "Hayır" --> SONNET["Sonnet<br/>~$0.75/görev<br/>En iyi denge"]

    style HAIKU fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style SONNET fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
    style OPUS fill:#2d1117,stroke:#f85149,stroke-width:2px,color:#f85149
```

## Command vs Skill vs Subagent vs Agent Team?

```mermaid
graph TD
    START["Ne zaman çalışsın?"] --> EXPLICIT{"Çalışma zamanını<br/>siz mi kontrol<br/>edeceksiniz?"}
    EXPLICIT -- "Evet" --> CMD["⌨️ Slash Command<br/><small>/deploy, /test, /security-review</small>"]
    EXPLICIT -- "Hayır" --> AUTO{"Context'e göre<br/>otomatik mi<br/>uygulanmalı?"}
    AUTO -- "Evet" --> SKILL["📚 Skill<br/><small>Güvenlik pattern'ları, kod standartları</small>"]
    AUTO -- "Hayır" --> ISO{"İzole context<br/>gerekli mi?"}
    ISO -- "Hayır" --> DIRECT["💬 Doğrudan prompt<br/><small>Her şey soyutlama gerektirmez</small>"]
    ISO -- "Evet" --> MANY{"Tek görev mi<br/>çoklu paralel mi?"}
    MANY -- "Tek" --> SUB["🤖 Subagent<br/><small>Task tool ile derin keşif</small>"]
    MANY -- "Çoklu" --> TEAM["👥 Agent Team<br/><small>5 agent paralel review</small>"]

    style CMD fill:#1a1a3e,stroke:#a855f7,stroke-width:1px,color:#c084fc
    style SKILL fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style DIRECT fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
    style SUB fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
    style TEAM fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
```

## Hook vs Prompt?

```mermaid
graph TD
    START["Aksiyon HER ZAMAN<br/>çalışmalı mı?"] --> ALWAYS{"Claude'un kararından<br/>bağımsız mı?"}
    ALWAYS -- "Evet" --> HOOK["🔒 Hook - Deterministik<br/><small>Format, lint, log, .env engelle</small><br/><small>Claude atlayamaz, unutamaz</small>"]
    ALWAYS -- "Hayır" --> PROMPT["💭 Prompt - Olasılıksal<br/><small>'Test eklemeyi düşün'</small><br/><small>'Edge case'leri kontrol et'</small><br/><small>Claude context'e göre karar verir</small>"]

    style HOOK fill:#2d1117,stroke:#f85149,stroke-width:2px,color:#f85149
    style PROMPT fill:#1a1a3e,stroke:#a855f7,stroke-width:1px,color:#c084fc
```

## When to Use Extended Thinking?

| Durum                                         | Extended Thinking? |
| --------------------------------------------- | ------------------ |
| Birçok trade-off içeren mimari karar          | ✅ Evet             |
| Kök nedeni belirsiz karmaşık debugging        | ✅ Evet             |
| Dikkatli muhakeme gerektiren güvenlik analizi | ✅ Evet             |
| Tanımadığınız codebase'i anlama               | ✅ Evet             |
| Rutin bug fix                                 | ❌ Hayır            |
| Basit refactoring                             | ❌ Hayır            |
| Kod formatlama                                | ❌ Hayır            |
| Hızlı sorular                                 | ❌ Hayır            |

Session içinde `Alt+T` ile açıp kapatın. Yüksek thinking budget'ı daha pahalıdır; minimumdan başlayın, yanıtlar acele hissettirirse artırın.

> **Opus 4.6 adaptive thinking:** Opus 4.6, problem karmaşıklığına göre thinking derinliğini otomatik ayarlar. Çoğu görev için manuel thinking kontrolü gerekmez - zor problemlerde derinleşir, basit olanlarda hızlı kalır. Manuel thinking toggle'ı en çok Sonnet'te daha derin analiz zorlamak istediğinizde işe yarar.

## Which Execution Surface?

```mermaid
graph TD
    START["İş nerede çalışmalı?"] --> LOCAL{"Yerel dosya ve<br/>tool gerekli mi?"}
    LOCAL -- "Evet" --> INTERACTIVE{"İnteraktif mi?"}
    INTERACTIVE -- "Evet" --> REPL["🖥️ Main REPL session"]
    INTERACTIVE -- "Hayır" --> ONESHOT{"CI/CD mi?"}
    ONESHOT -- "Evet" --> CICD["⚙️ claude -p --json<br/><small>non-interactive + structured output</small>"]
    ONESHOT -- "Hayır" --> PRINT["📋 claude -p 'prompt'<br/><small>print mode, one-shot</small>"]
    LOCAL -- "Hayır" --> REMOTE{"Araştırma mı?"}
    REMOTE -- "Evet" --> EXPLORE["🔍 Subagent Explore"]
    REMOTE -- "Hayır" --> WEB["🌐 WebFetch / WebSearch"]

    style REPL fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
    style CICD fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style PRINT fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style EXPLORE fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
    style WEB fill:#1a1a3e,stroke:#a855f7,stroke-width:1px,color:#c084fc
```

| Senaryo                      | Yüzey                   | Neden                              |
| ---------------------------- | ----------------------- | ---------------------------------- |
| Hatalı test debug            | Main REPL               | Yerel dosyalar, iteratif           |
| 20 GitHub issue triage       | Background agent        | Uzun süren, yerel dosya gereksiz   |
| PR review                    | Subagent veya --from-pr | İzole context, odaklı çıktı        |
| Changelog oluşturma          | `claude -p`             | One-shot, scriptable               |
| Her commit'te lint + test    | Hook (PreCommit)        | Her zaman çalışmalı, deterministik |
| Repo'lar arası pattern arama | Subagent (Explore)      | Context bloat'u önler              |
| Hızlı kod açıklama           | Main REPL veya /fast    | İnteraktif, hızlı yanıt            |
| Multi-modül refactor         | Agent team              | Dosyalar arası paralel çalışma     |

## Agent Teams vs Subagents vs Parallel Sessions

```mermaid
graph TD
    START["Birden fazla agent<br/>gerekli mi?"] --> MULTI{"İlişkili alt<br/>görevler var mı?"}
    MULTI -- "Hayır" --> SINGLE["Tek Subagent veya Main REPL"]
    MULTI -- "Evet" --> INDEP{"Alt görevler<br/>bağımsız mı?"}
    INDEP -- "Hayır" --> SEQ["Sıralı Subagent'lar<br/><small>Explore → Plan → Implement</small>"]
    INDEP -- "Evet" --> SHARED{"Aynı codebase'i<br/>paylaşabilir mi?"}
    SHARED -- "Evet" --> ATEAM["👥 Agent Team<br/><small>Opus koordine eder</small>"]
    SHARED -- "Hayır" --> PARALLEL["🖥️ Parallel Sessions<br/><small>Ayrı terminaller</small>"]

    style ATEAM fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style SEQ fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style PARALLEL fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
```

| Yaklaşım          | Max Parallelism             | Paylaşılan Context                | Koordinasyon                |
| ----------------- | --------------------------- | --------------------------------- | --------------------------- |
| Agent Team        | 5-10 agent                  | Paylaşılan repo, ayrı context'ler | Opus koordine eder          |
| Subagents         | Sınırsız (siz yönetirsiniz) | Yok (izole)                       | Prompt ile siz yönetirsiniz |
| Parallel Sessions | Terminal sayısıyla sınırlı  | Yok                               | Manuel                      |

## Which Hook Type?

```mermaid
graph TD
    START["Ne tür otomasyon<br/>gerekli?"] --> SHELL{"Belirli event'te<br/>shell komutu mu?"}
    SHELL -- "Evet" --> CMD["🔧 Command Hook<br/><small>prettier --write $FILE</small>"]
    SHELL -- "Hayır" --> SYSPROMPT{"System prompt'u<br/>context'e göre<br/>değiştirmek mi?"}
    SYSPROMPT -- "Evet" --> PHOOK["📝 Prompt Hook<br/><small>/src/auth/ düzenlerken kuralları enjekte et</small>"]
    SYSPROMPT -- "Hayır" --> AGENT["🧠 Agent Hook<br/><small>Bu bash komutu güvenli mi? değerlendir</small>"]

    style CMD fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
    style PHOOK fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style AGENT fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
```

**Hook event'leri:** `PreToolUse` · `PostToolUse` · `Notification` · `Stop` · `SubagentStop`

## When to Use /fast?

```mermaid
graph LR
    START["Hız mı derinlik mi?"] --> SPEED{"Yanıt hızı<br/>derinlikten<br/>önemli mi?"}
    SPEED -- "Evet" --> FAST["⚡ /fast<br/><small>Hızlı soru, basit edit, formatlama</small>"]
    SPEED -- "Hayır" --> NORMAL["🧠 Normal mod<br/><small>Mimari, debug, güvenlik, refactor</small>"]

    style FAST fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style NORMAL fill:#1c1208,stroke:#eab308,stroke-width:2px,color:#facc15
```

`/fast` aynı modeli (Opus 4.6) optimize edilmiş çıktı hızıyla kullanır - daha ucuz bir modele geçmez.
