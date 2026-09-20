# Unity 2D Platform Oyunu

Unity ve C# kullanılarak geliştirilen, Mario tarzı temel platform mekaniklerini gösteren kısa bir 2D oyun çalışmasıdır. Üniversite dönemindeki başlangıç projesinin düzenlenmiş ve geliştirilmiş sürümüdür.

## Özellikler

- Sağ/sol hareket ve zıplama
- Yumuşak kamera takibi
- Farklı yüksekliklerde platformlar
- Toplanabilir yıldızlar ve skor göstergesi
- Tehlikeli alanlar ve yeniden doğma sistemi
- Bitiş bayrağı ve bölüm tamamlama ekranı
- Haricî görsel dosya gerektirmeyen çalışma zamanı seviye oluşturma

## Kontroller

- **A / D** veya **Sol / Sağ Ok:** Hareket
- **W**, **Yukarı Ok** veya **Space:** Zıplama
- **R:** Bölümü tamamladıktan sonra yeniden başlatma

## Kullanılan Teknolojiler

- Unity 2022.3.57f1
- C#
- Visual Studio
- Unity 2D Physics

## Proje Yapısı

- `GameBootstrap.cs`: Bölümü, oyuncuyu, platformları ve nesneleri oluşturur.
- `PlayerController.cs`: Oyuncu hareketi, zıplama ve yeniden doğma.
- `CameraFollow.cs`: Yumuşak kamera takibi.
- `Coin.cs`: Toplanabilir yıldız davranışı.
- `Hazard.cs`: Tehlikeli alanlar.
- `Goal.cs`: Bitiş noktası.
- `GameManager.cs`: Skor ve bölüm tamamlama ekranı.

## Çalıştırma

1. Projeyi Unity Hub üzerinden **Unity 2022.3.57f1** ile açın.
2. `Assets/Scenes/SampleScene.unity` sahnesini açın.
3. **Play** düğmesine basın.

## Not

Bu proje, profesyonel oyun geliştirme deneyimi iddiası taşımaz. C#, Unity ve temel 2D oyun mekaniği çalışmalarını göstermek amacıyla hazırlanmış akademik/kişisel bir portföy projesidir.

## Geliştirici

Ali Danış — Mobil Teknolojileri mezunu, Junior Flutter ve Mobil Uygulama Geliştirici adayı.

