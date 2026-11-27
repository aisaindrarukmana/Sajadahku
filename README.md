# SajadahKu – Flutter JO-01

Project Flutter dasar untuk aplikasi jadwal dan presensi sholat offline.

## Persyaratan
- Flutter SDK dan Android SDK
- VS Code atau Android Studio

## Menjalankan
```bash
flutter doctor
flutter pub get
flutter run
```

Jika folder platform Android belum ada:
```bash
flutter create --platforms=android .
```

## Membuat APK
```bash
flutter analyze
flutter build apk --release
```
Hasil APK: `build/app/outputs/flutter-apk/app-release.apk`

## Fitur dalam project
- Beranda dengan jadwal hari ini
- CRUD jadwal sholat per tanggal
- Time Picker dan validasi urutan waktu
- Presensi per waktu sholat
- Riwayat dan filter status
- Pengaturan nama dan tema
- SQLite untuk jadwal/presensi
- Shared Preferences untuk nama dan tema

Catatan: project ini adalah source awal yang perlu dijalankan dan diuji pada perangkat/emulator Android. Sesuaikan tampilan dan skenario pengujian dengan jobsheet sekolah.
