# TaskFlow — Flutter Görev Takip Uygulaması

[![TaskFlow CI](https://github.com/alidanis61615/index/actions/workflows/taskflow-ci.yml/badge.svg)](https://github.com/alidanis61615/index/actions/workflows/taskflow-ci.yml)

TaskFlow, Flutter ve Dart ile geliştirilen; görevleri cihazda SQLite ile saklayan, arama/filtreleme ve açık-koyu tema desteği bulunan bir mobil portföy projesidir.

## Özellikler

- Görev ekleme, düzenleme ve silme
- Tamamlandı / bekliyor durumu
- Düşük / orta / yüksek öncelik
- Son tarih seçimi
- Görevlerde arama
- Tümü / Aktif / Tamamlanan filtreleri
- Toplam / aktif / tamamlanan istatistikleri
- SQLite ile kalıcı yerel veri saklama
- Açık / koyu tema
- Material 3 arayüz
- Silinen görev için geri alma

## Teknolojiler

Flutter • Dart • SQLite • Material 3 • SharedPreferences • Git/GitHub

## Çalıştırma

```bash
flutter create .
flutter pub get
flutter run
```

> **v0.3 aktif geliştirme:** Görev düzenleme, açıklama, öncelik ve son tarih akışı eklendi. Firebase Authentication, Firestore, bildirimler ve ek testler sonraki sürüm hedefleridir.

## CV için kısa açıklama

**TaskFlow — Görev Takip Uygulaması | Flutter • Dart • SQLite • Git**

Görev ekleme, düzenleme, silme ve tamamlanma takibi; öncelik ve son tarih yönetimi, arama/filtreleme, açık-koyu tema ve SQLite tabanlı yerel veri saklama özelliklerine sahip Material 3 mobil uygulama.

## Kalite Kontrolü

GitHub Actions ile her TaskFlow değişikliğinde `flutter analyze` ve `flutter test` otomatik çalıştırılır.
