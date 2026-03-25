# Quick Reference Card

```
╔═══════════════════════════════════════════════════════════════╗
║                    CLAUDE CODE QUICK REFERENCE                ║
╠═══════════════════════════════════════════════════════════════╣
║  MODELLER                                                     ║
║    haiku      $1/$5/M     Keşif, basit görevler               ║
║    sonnet     $3/$15/M    Günlük kodlama (varsayılan)         ║
║    opus       $5/$25/M    Opus 4.6: mimari, zor problemler    ║
║    opus[1m]   $10/$37.50  1M context (Max/Team varsayılan)    ║
║    sonnet[1m] $6/$22.50/M Büyük codebase (1M context)         ║
╠═══════════════════════════════════════════════════════════════╣
║  TEMEL KOMUTLAR                                               ║
║    /compact        Context azalt (%50'de yap)                 ║
║    /cost           Session harcamasını kontrol et             ║
║    /model opus     Opus'a geç                                 ║
║    /status         Mevcut durumu göster                       ║
║    /voice          Ses modunu aç/kapat (push-to-talk)         ║
║    /init           Proje config'ini kur                       ║
║    /mcp            Entegrasyonları yapılandır                 ║
║    /copy [N]       Kod bloklarını kopyala (N. yanıt)          ║
║    /memory         Auto-memory görüntüle ve yönet             ║
║    /simplify       Kodu sadeleştir (v2.1.63+)                 ║
║    /batch          Toplu işlemler (v2.1.63+)                  ║
║    /effort         Efor seviyesi (low/medium/high)            ║
║    /loop 5m /foo   Tekrarlayan interval'da çalıştır           ║
║    claude -n name  Session'ı isimle başlat                    ║
║    claude agents   Tüm agent'ları listele (CLI)               ║
║    claude -w       İzole git worktree'de başlat               ║
║    claude -c       Son session'a devam et                     ║
║    claude -p       Scripted mod (hook/LSP/plugin yok)         ║
╠═══════════════════════════════════════════════════════════════╣
║  KLAVYE KISAYOLLARI                                           ║
║    Alt+T           Extended thinking aç/kapat                 ║
║    Shift+Tab       Permission modları arasında geç            ║
║    Ctrl+C          Mevcut işlemi kesintiye uğrat              ║
║    Ctrl+F          Tüm arka plan agent'ları durdur            ║
║    Esc → Esc       Son değişikliği geri al                    ║
║    Ctrl+L          Ekranı temizle                             ║
╠═══════════════════════════════════════════════════════════════╣
║  PREFIX'LER                                                   ║
║    #mesaj          Kalıcı memory'ye ekle                      ║
║    @path/dosya     Prompt'ta dosya referansı                  ║
║    !komut          Bash'i doğrudan çalıştır                   ║
║    &görev          Cloud'a gönder (async)                     ║
╠═══════════════════════════════════════════════════════════════╣
║  CONFIG DOSYA HİYERARŞİSİ (ilk bulunan kazanır)               ║
║    .claude/settings.local.json    Kişisel (gitignored)        ║
║    .claude/settings.json          Proje (paylaşılan)          ║
║    ~/.claude/settings.json        Kullanıcı global            ║
║    /etc/.../managed-settings.json Enterprise (kilitli)        ║
║    CLAUDE.md                      Proje context'i             ║
╠═══════════════════════════════════════════════════════════════╣
║  GÜNLÜK WORKFLOW                                              ║
║    1. claude -c              Session'a devam et               ║
║    2. Feature'lar üzerinde çalış  Sonnet kullan               ║
║    3. /compact               Context şişmeden                 ║
║    4. /cost                  Harcamayı kontrol et             ║
║    5. Özetle                 Temiz çıkış                      ║
╠═══════════════════════════════════════════════════════════════╣
║  KARAR KURALLARI                                              ║
║    Basit görev?       → Haiku                                 ║
║    Zor muhakeme?      → Opus                                  ║
║    Diğer her şey?     → Sonnet                                ║
║    Her zaman çalışmalı → Hook (prompt değil)                  ║
║    Otomatik uzmanlık? → Skill (command değil)                 ║
║    İzolasyon gerekli? → Subagent                              ║
╚═══════════════════════════════════════════════════════════════╝
```

