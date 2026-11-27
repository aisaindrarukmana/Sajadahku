# 🕌 SajadahKu – Flutter JO-01

Project Flutter dasar untuk aplikasi jadwal dan presensi sholat offline.

SajadahKu adalah aplikasi pengelolaan jadwal dan presensi sholat dengan fitur khusus untuk perempuan saat berhalangan (haid).

Aplikasi ini membantu pengguna untuk mengatur jadwal sholat, mencatat kehadiran sholat harian, melihat riwayat, dan memantau rekap kehadiran secara mudah dan teratur.

> SajadahKu — Selangkah lebih dekat pada-Nya ♡

## ✨ Fitur Utama

- 🕐 Jadwal Sholat Lengkap - Bisa ditambah & disesuaikan secara manual
- ✅ Presensi Sholat Harian - Tandai Hadir / Belum untuk Subuh, Dzuhur, Ashar, Maghrib, Isya
- 📋 Riwayat Presensi - Lihat presensi per hari, mingguan, dan semua riwayat
- 📊 Rekap Kehadiran - Persentase kehadiran, Tepat Waktu, Terlambat, Tidak Hadir, Berhalangan
- 🔔 Notifikasi Pengingat - Pengingat waktu sholat
- 🌸 Fitur Berhalangan (Haid) - Khusus perempuan, tidak dihitung sebagai ketidakhadiran dan tidak mempengaruhi persentase kehadiran
- 👤 Login / Daftar Akun & Masuk sebagai Tamu
- 🎨 Tema Terang & Gelap
- 🌐 Bahasa Indonesia
- 📱 Bisa Digunakan Offline

## 📱 Tampilan Aplikasi

- **Splash Screen** - Halaman pembuka aplikasi
- **Onboarding** - Pengenalan aplikasi
- **Login / Daftar** - Masuk dengan akun atau sebagai Tamu
- **Home** - Info sholat berikutnya & status presensi hari ini
- **Jadwal Sholat** - Daftar jadwal sholat harian
- **Tambah Jadwal** - Tambah jadwal sholat baru dengan pengingat
- **Presensi Sholat** - Isi presensi harian + catatan opsional
- **Riwayat Presensi** - Riwayat presensi per tanggal
- **Rekap** - Rekap kehadiran 7 Hari, 30 Hari, 90 Hari
- **Pengaturan** - Profil, Tema, Notifikasi, Fitur Haid, Bahasa, Reset Data
- **Tentang Aplikasi** - Informasi aplikasi SajadahKu v1.0.0

## 📋 Persyaratan

- Flutter SDK dan Android SDK
- VS Code atau Android Studio

## 🚀 Cara Menjalankan

```bash
flutter doctor
flutter pub get
flutter run


## 👨‍💻 Identitas Pengembang

| | Anggota 1 | Anggota 2 |
| :--- | :--- | :--- |
| **Nama Lengkap** | Aisa Indra Rukmana | Safira Qurotul Hidayah |
| **Kelas** | 11 RPL 2 | 11 RPL 2 |
| **Sekolah** | SMK Negeri 10 Semarang | SMK Negeri 10 Semarang |
| **Mata Pelajaran** | LKPD Pengembangan Aplikasi Mobile | LKPD Pengembangan Aplikasi Mobile |
| **GitHub** | https://github.com/aisarukmana | https://github.com/safirahidayah |
| **Tahun** | 2026 | 2026 |

---
Dibuat dengan ❤️ menggunakan Flutter - Tim Pengembang SajadahKu



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
