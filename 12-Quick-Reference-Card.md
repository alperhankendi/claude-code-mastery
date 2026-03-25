# Quick Reference Card

## Modeller

> [!TIP]
> | Alias | Fiyat (Input/Output) | Kullanım |
> |-------|---------------------|----------|
> | `haiku` | $1 / $5 per MTok | Keşif, basit görevler |
> | `sonnet` | $3 / $15 per MTok | Günlük kodlama (varsayılan) |
> | `opus` | $5 / $25 per MTok | Mimari, zor problemler |
> | `opus[1m]` | $10 / $37.50 per MTok | 1M context, büyük codebase |
> | `sonnet[1m]` | $6 / $22.50 per MTok | 1M context |

## Temel Komutlar

> [!NOTE]
> | Komut | Açıklama |
> |-------|----------|
> | `/compact` | Context azalt (%50'de yap) |
> | `/cost` | Session harcamasını kontrol et |
> | `/model opus` | Opus'a geç |
> | `/status` | Mevcut durumu göster |
> | `/voice` | Ses modunu aç/kapat |
> | `/mcp` | Entegrasyonları yapılandır |
> | `/memory` | Auto-memory görüntüle ve yönet |
> | `/simplify` | Kodu sadeleştir |
> | `/batch` | Toplu işlemler |
> | `/effort` | Efor seviyesi (low/medium/high) |
> | `/loop 5m /foo` | Tekrarlayan interval'da çalıştır |

## CLI Flags

> [!NOTE]
> | Flag | Açıklama |
> |------|----------|
> | `claude -c` | Son session'a devam et |
> | `claude -n name` | Session'ı isimle başlat |
> | `claude -w` | İzole git worktree'de başlat |
> | `claude -p` | Scripted mod (hook/LSP/plugin yok) |
> | `claude agents` | Tüm agent'ları listele |

## Klavye Kısayolları

> [!IMPORTANT]
> | Kısayol | Açıklama |
> |---------|----------|
> | `Alt+T` | Extended thinking aç/kapat |
> | `Shift+Tab` | Permission modları arasında geç |
> | `Ctrl+C` | Mevcut işlemi kesintiye uğrat |
> | `Ctrl+F` | Tüm arka plan agent'ları durdur |
> | `Esc` `Esc` | Son değişikliği geri al |
> | `Ctrl+L` | Ekranı temizle |

## Prefix'ler

> [!WARNING]
> | Prefix | Açıklama |
> |--------|----------|
> | `#mesaj` | Kalıcı memory'ye ekle |
> | `@path/dosya` | Prompt'ta dosya referansı |
> | `!komut` | Bash'i doğrudan çalıştır |
> | `&görev` | Cloud'a gönder (async) |

## Config Dosya Hiyerarşisi

> [!CAUTION]
> İlk bulunan kazanır (yukarıdan aşağıya öncelik):
>
> | Dosya | Kapsam |
> |-------|--------|
> | `.claude/settings.local.json` | Kişisel (gitignored) |
> | `.claude/settings.json` | Proje (paylaşılan) |
> | `~/.claude/settings.json` | Kullanıcı global |
> | `/etc/.../managed-settings.json` | Enterprise (kilitli) |
> | `CLAUDE.md` | Proje context'i |
>
> Detay: [01 - Configuration System](01-Claude-Code-Complete-Guide.md#configuration-system)

## Günlük Workflow

> [!TIP]
> ```
> 1. claude -c              → Session'a devam et
> 2. Feature'lar üzerinde çalış → Sonnet kullan
> 3. /compact               → Context şişmeden
> 4. /cost                  → Harcamayı kontrol et
> 5. Özetle                 → Temiz çıkış
> ```

## Karar Kuralları

> [!IMPORTANT]
> | Durum | Karar |
> |-------|-------|
> | Basit görev? | Haiku |
> | Zor muhakeme? | [Opus](02-Which-Model-Should-I-Choose.md#when-to-use-each-model) |
> | Diğer her şey? | Sonnet |
> | Her zaman çalışmalı? | [Hook](04-How-To-Hooks-Work.md) (prompt değil) |
> | Otomatik uzmanlık? | [Skill](07-How-Do-Skills-Work.md) (command değil) |
> | İzolasyon gerekli? | [Subagent](06-What-are-Subagents.md) |
>
> Karar ağaçları: [03 - Decision Framework](03-Decision-Framework.md)
