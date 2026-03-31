# Superpowers - The Discipline Enforcer

GitHub Stars: Growing | License: MIT

Superpowers benzersiz bir niş işgal eder. Öncelikli olarak bir specification framework'ü (SpecKit veya OpenSpec gibi), bir enterprise takım simülatörü (BMAD gibi) veya bir context orkestrasyon motoru (GSD gibi) değildir. Bir **disiplin zorunluluk sistemidir**. GSD'ye en yakın buluyorum, ancak TDD konusunda çok daha katı.

## Onu Farklı Kılan Ne?

### Zorunlu Brainstorming Gate'i

Herhangi bir kod yazılmadan önce, Superpowers geliştirici ve AI agent arasında yapılandırılmış bir diyaloğu zorlar. Bu opsiyonel değildir. Agent, bir tasarım sunulup onaylanana kadar kod yazmaktan, proje iskeletlemekten veya herhangi bir implementation eylemi almaktan açıkça men edilmiştir.

BMAD'in benzer bir analiz fazı vardır, ancak Superpowers'ın gate'i daha serttir: geçici çözüm yoktur, "bu tasarım gerektirmeyecek kadar basit" kaçış kapısı yoktur. GSD'nin milestone ve planlama tartışmaları vardır ama atlanabilir.

### TDD Demir Kuralı

Diğer framework'ler test yazmayı önerir. Superpowers bunu bir **sil-ve-yeniden-yaz kuralıyla** dayatır: agent, başarısız bir test olmadan production kodu yazarsa, kod silinir. Referans için saklanmaz. Uyarlanmaz. **Silinir.**

Bu, bu karşılaştırmadaki herhangi bir framework'ün en agresif test zorunluluğudur.

### İkna Bazlı Koruma Rayları

Superpowers, AI agent'ların psikolojisini açıkça ele alır. Modellerin adımları atlamak için kullandığı rasyonalizasyonları isimlendirir ("bu test etmek için çok basit", "testleri sonra yazacağım", "bunu hızlıca düzelteyim") ve bunları önceden engeller.

Skill'ler sosyal mühendisliğe karşı stres testi yapılmıştır: yaratıcı, aciliyet simüle ederek ve uyumu izleyerek agent'ı köşe kesmeye ikna etmeye kasıtlı olarak çalışır.

### İki Aşamalı Review ile Subagent Dispatch

GSD gibi, Superpowers da context pollution'ı önlemek için taze subagent context'leri kullanır. Ancak GSD paralel çalıştırma hızına odaklanırken, Superpowers **kalite gate'lerine** odaklanır.

Her subagent'ın çıktısı, workflow ilerlemeden önce **spec uyumluluk review'u** ve **kod kalite review'undan** geçer. Muhtemelen GSD ile aynı token kullanım kısıtlamalarına sahiptir. Daha fazlasını yapar. Daha fazla kullanırsınız. Her ikisi de bir maliyeti olan context rot'u önlemeye çalışır, ancak doğruluk muhtemelen maliyetine değer.

## Pratikte Trade-Off

Superpowers'ın temel trade-off'u **güvenilirlik vs hızdır**. Zorunlu brainstorming, TDD dayatması ve iki aşamalı review, bu karşılaştırmadaki herhangi bir framework'ün en tutarlı yüksek kaliteli çıktısını üretir (GSD yakın ikinci olarak). Ancak her kalite gate'i zaman ekler.

Ham bir Claude Code session'ında 10 dakika süren bir görev, Superpowers'ın tam pipeline'ı üzerinden 30 dakika sürebilir. Soru şudur: bug'lardan, yeniden çalışmadan ve mimari hatalardan kaçınarak kazanılan zaman, ön disipline harcanan zamanı aşar mı?

* **Production sistemleri** (bug'ların maliyetli olduğu): cevap neredeyse her zaman **evet**
* **Prototip ve tek kullanımlık kod**: cevap neredeyse her zaman **hayır**

## Ne Zaman Kullanmalı

* Kalite kritik production sistemleri
* TDD kültürü olan veya oluşturmak isteyen takımlar
* Bug maliyetinin yüksek olduğu sektörler (finans, sağlık, altyapı)
* AI agent'ın disiplinsiz davranma eğiliminin sorun olduğu projeler

## Ne Zaman Gereksiz

* Hızlı prototipleme ve kavram kanıtları
* Tek kullanımlık script'ler ve deney kodu
* Test yazmanın anlamsız olduğu basit konfigürasyon değişiklikleri

## Nasıl Karşılaştırılır?

Superpowers bu karşılaştırmadaki en katı görüşlü framework'tür. Esnekliği güvenilirlik karşılığında takas eder. Brainstorming fazını atlayamazsınız. Testlerden önce kod yazamazsınız. Code review'u bypass edemezsiniz.

Bu kısıtlamalar, iyi anladıkları görevlerde hızlı hareket etmek isteyen deneyimli geliştiriciler için süreci yavaşlatır, ancak kod kalitesinin hızdan daha önemli olduğu takımlar için en güvenli seçim haline getirir.
