# Common Anti-Patterns

Yapılmaması gerekeni öğrenmek, çoğu zaman en iyi pratiklerden daha değerlidir. Bu pattern'lar sürekli sorun yaratır:

## Cost Anti-Patterns

| Anti-pattern                       | Problem                                                         | Çözüm                                                                                                  |
| ---------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Her şey için Opus kullanmak        | 5 kat maliyet, çoğu zaman gereksiz                              | [Varsayılan Sonnet, Opus sadece mimari için](02-Which-Model-Should-I-Choose.md#when-to-use-each-model) |
| /cost kontrol etmemek              | Sürpriz faturalar                                               | Büyük görevlerden sonra maliyet kontrol et                                                             |
| Basit görevlerde extended thinking | Token israfı                                                    | Rutin iş için kapat (Alt+T)                                                                            |
| Keşfi ana context'te yapmak        | [Context bloat](06-What-are-Subagents.md#what-is-context-bloat) | [Explore subagent kullan](06-What-are-Subagents.md#subagent-types)                                     |

## Context Anti-Patterns

| Anti-pattern                          | Problem                             | Çözüm                                |
| ------------------------------------- | ----------------------------------- | ------------------------------------ |
| Context şişene kadar görmezden gelmek | Bozulan muhakeme, unutulan kararlar | %50 kapasitede proaktif /compact     |
| Bölüm gerekirken tüm dosyayı okumak   | Alakasız kodla context israfı       | Spesifik satır aralıkları referansla |
| Subagent hiç kullanmamak              | Her şey ana context'i doldurur      | Keşif ve analizi delegasyon et       |
| Dev CLAUDE.md dosyaları               | Her session'da context israfı       | 500 satır altında tut, import kullan |

## Workflow Anti-Patterns

| Anti-pattern                      | Problem                            | Çözüm                                |
| --------------------------------- | ---------------------------------- | ------------------------------------ |
| Örtüşen skill ve command'lar      | Karışıklık, öngörülemeyen davranış | Her amaç için tek mekanizma          |
| Garantili aksiyonlar için prompt  | Claude atlayabilir veya unutabilir | Zorunlu çalışanlar için hook kullan  |
| Formatlama için hook olmaması     | Tutarsız kod stili                 | Her Edit/Write'a formatter hook'la   |
| Varsayılan olarak tüm bash'e izin | Güvenlik riski                     | Güvenli komutlar için açık allowlist |

## Configuration Anti-Patterns

| Anti-pattern                        | Problem                             | Çözüm                                    |
| ----------------------------------- | ----------------------------------- | ---------------------------------------- |
| Tüm config kullanıcı settings'inde  | Takımla paylaşılan bir şey yok      | Takım standartları için project settings |
| Kişisel tercihleri commit'lemek     | Takım arkadaşlarını override eder   | Kişisel için settings.local.json kullan  |
| Deny kuralı olmaması                | Claude hassas dosyalara dokunabilir | .env, credentials, secrets'ı deny'la     |
| Managed settings'i görmezden gelmek | Enterprise politikaları atlanır     | Uyumluluk için managed settings          |

## Prompt Anti-Patterns //TODO:Agentic book ref.

| Anti-pattern                          | Problem                      | Çözüm                                  |
| ------------------------------------- | ---------------------------- | -------------------------------------- |
| "Daha iyi yap"                        | Belirsiz, kötü sonuçlar      | "Daha iyi"nin ne demek olduğunu belirt |
| Dosya referansı vermemek              | Claude yolları tahmin eder   | @path/to/file.ts syntax'ı kullan       |
| Claude'un sorularını görmezden gelmek | Yanlış varsayımlarla çalışır | Devam etmeden önce yanıtla             |
| Parça yeterken tam doku vermek        | Context israfı               | İlgili bölümleri çıkar                 |

