# BMAD Method - AI-Driven Agile Development Framework

[BMAD](https://docs.bmad-method.org/) (Build More Architect Dreams), Claude Code'u yapılandırılmamış bir araçtan organize bir geliştirme takımına dönüştüren açık kaynak (MIT) bir framework'tür. İdeasyondan implementation'a kadar tüm yazılım geliştirme sürecini kapsar.

## Nedir?

Geleneksel geliştirmede Product Manager, Architect, Developer, QA gibi roller vardır. BMAD bu rollerin her birini Claude Code içinde özelleşmiş AI agent olarak tanımlar. Sonuç: tek bir Claude Code session'ında tam bir agile takım simülasyonu.

21 özelleşmiş agent, 50+ guided workflow ve documentation-first yaklaşımıyla BMAD, Claude Code'u tahmin edilemez bir araçtan yapılandırılmış bir geliştirme takımına dönüştürür.

## Agent Rolleri

| Agent                     | Rol              | Ne Yapar                                                   |
| ------------------------- | ---------------- | ---------------------------------------------------------- |
| **BMad Master**           | Orkestratör      | Diğer agent'ları koordine eder, workflow yönetir           |
| **Business Analyst**      | İş Analisti      | Gereksinim toplama, kullanıcı hikayeleri, kabul kriterleri |
| **Product Manager**       | Ürün Yöneticisi  | Önceliklendirme, roadmap, feature scope belirleme          |
| **System Architect**      | Mimar            | Teknik tasarım, mimari kararlar, teknoloji seçimi          |
| **UX Designer**           | Tasarımcı        | Kullanıcı akışları, wireframe, UI pattern'lar              |
| **Scrum Master**          | Süreç Yöneticisi | Sprint planlama, görev bölümü, ilerleme takibi             |
| **Developer**             | Geliştirici      | Implementation, code review, refactoring                   |
| **Builder**               | İnşacı           | CI/CD, altyapı, deployment                                 |
| **Creative Intelligence** | Yaratıcı         | Alternatif yaklaşımlar, problem çözme                      |

## Workflow Fazları

```mermaid
graph LR
    IDEA["Ideation"] --> PLAN["Planning"]
    PLAN --> ARCH["Architecture"]
    ARCH --> IMPL["Implementation"]
    IMPL --> TEST["Testing"]
    TEST --> DEPLOY["Deployment"]

    style IDEA fill:#1a1a3e,stroke:#a855f7,stroke-width:1px,color:#c084fc
    style PLAN fill:#0f2027,stroke:#3b82f6,stroke-width:1px,color:#60a5fa
    style ARCH fill:#1c1208,stroke:#eab308,stroke-width:1px,color:#facc15
    style IMPL fill:#132213,stroke:#22c55e,stroke-width:1px,color:#4ade80
    style TEST fill:#132213,stroke:#22c55e,stroke-width:2px,color:#4ade80
    style DEPLOY fill:#0f2027,stroke:#3b82f6,stroke-width:2px,color:#60a5fa
```

Her fazda ilgili agent otomatik devreye girer. Business Analyst gereksinim toplar, Architect tasarlar, Developer implement eder. Tümü documentation-first yaklaşımıyla yapılmaktadr.

## Superpowers vs BMAD

| Özellik            | Superpowers                      | BMAD                                           |
| ------------------ | -------------------------------- | ---------------------------------------------- |
| **Kapsam**         | 6 fazlı geliştirme döngüsü       | Tam agile takım simülasyonu (9+ agent)         |
| **Yaklaşım**       | Lifecycle fazları                | Rol bazlı agent'lar                            |
| **Karmaşıklık**    | Orta - tek feature geliştirme    | Yüksek - proje bazlı, çok modüllü              |
| **Ne zaman**       | Feature ekleme, bug fix workflow | Sıfırdan proje başlatma, enterprise geliştirme |
| **Öğrenme eğrisi** | Düşük                            | Orta-yüksek                                    |

## Ne Zaman Kullanmalı

* Sıfırdan yeni proje başlatırken (greenfield)
* Karmaşık, çok modüllü enterprise uygulamalar
* Yapılandırılmış agile süreç gerektiğinde
* Dokümantasyon-first yaklaşım istediğinizde

## Ne Zaman Gereksiz

* Basit bug fix veya küçük feature
* Tek dosya düzenleme
* Mevcut projeye hızlı ekleme (Superpowers veya feature-dev daha uygun)



> **Kaynaklar:**
>
> * [BMAD Method Docs](https://docs.bmad-method.org/)
> * [GitHub - BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)
> * [BMAD for Claude Code](https://github.com/24601/BMAD-AT-CLAUDE)
> * [BMAD Skills Plugin](https://github.com/aj-geddes/claude-code-bmad-skills)

