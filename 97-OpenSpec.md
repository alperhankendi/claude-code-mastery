# OpenSpec - The Brownfield-First Alternative

GitHub Stars: 29.5k | License: MIT | Latest: v1.2.0 (Feb 2026) | [GitHub](https://github.com/openspec-dev/openspec) | [Site](https://openspec.dev)

SpecKit sıfırdan yeni sistemler inşa etmek için tasarlandıysa, OpenSpec mevcut kod tabanları üzerinde çalışmanın daha karmaşık gerçekliği için tasarlanmıştır.

OpenSpec'in felsefesi dört karşıtlıkla özetlenir: **"Esnek, katı değil; iteratif, waterfall değil; kolay, karmaşık değil; brownfield için inşa edilmiş, sadece greenfield için değil."** SpecKit katı faz gate'leri dayatırken, OpenSpec herhangi bir artifact'ı herhangi bir zamanda önceden belirlenmiş bir sıra takip etmeden güncellemenize izin verir.

## Delta Spec'ler

Temel inovasyon, **delta marker'lar aracılığıyla değişiklik izolasyonudur**. Mevcut bir işlevselliği değiştirdiğinizde tüm specification'ı baştan yazmak yerine, OpenSpec mevcut duruma göre neyin değiştiğini tanımlamak için `ADDED`, `MODIFIED` ve `REMOVED` marker'larını kullanır.

Her değişiklik kendi klasörünü alır (`openspec/changes/<isim>/`) ve içinde proposal, spec'ler, tasarım dokümanları ve görevler bulunur. Bu, bir değişikliğin diğerine müdahale etmesini önler.

```
openspec/
  changes/
    kullanici-yetkilendirme/
      proposal.md
      specs.md
      design.md
      tasks.md
    odeme-entegrasyonu/
      proposal.md
      specs.md
      design.md
      tasks.md
```

## Güçlü Yanları

OpenSpec değişiklik başına yaklaşık **250 satır** çıktı üretir, SpecKit'in yaklaşık **800 satırına** kıyasla. Bu overhead azalması, bir üretim sistemine günde beş değişiklik yaptığınızda önem kazanır.

**Fast-forward** komutu (`/opsx:ff`) tüm planlama artifact'larını tek seferde iskeletler, çok adımlı seremoniden kurtarır.

20+ AI aracı desteğiyle SpecKit kadar taşınabilirdir. Mevcut kod tabanlarında iteratif bakım, refactoring ve artımsal feature geliştirme yapan takımlar için OpenSpec en pragmatik seçenektir.

## Zayıf Yanları

SpecKit gibi, OpenSpec'in spec'leri de **statiktir**. Implementation ile otomatik olarak senkronize olmaz. Multi-agent orkestrasyon, paralel çalıştırma ve context izolasyon stratejisi yoktur.

Kapsamlı mimari dokümantasyon gerektiren büyük greenfield projelerde OpenSpec'in hafif yaklaşımı **yetersiz specification derinliği** üretebilir.

## Pratikte Trade-Off

OpenSpec, specification derinliğini hız karşılığında takas eder. Değişiklikleri daha hızlı çıkarsınız, ama birikmiş değişikliklerin tam mimari etkisini delta spec'lerin yakalayamayabileceği riskini kabul edersiniz.

Aylarca süren artımsal modifikasyonlarda, spec'lerin tanımladığı ile sistemin gerçekte yaptığı arasındaki uçurum sessizce büyüyebilir.

## Ne Zaman Kullanmalı

* Legacy modernizasyon ve brownfield projeler
* Mevcut sisteme iteratif feature ekleme
* Günlük birden fazla değişiklik yapılan üretim sistemleri
* Hafif overhead isteyen küçük-orta takımlar
* Refactoring ve bakım ağırlıklı çalışmalar

## Ne Zaman Gereksiz

* Kapsamlı mimari dokümantasyon gerektiren büyük greenfield projeler
* Paralel agent çalıştırma ihtiyacı olan senaryolar
* Spec'lerin otomatik senkronizasyonu zorunlu olan ortamlar
