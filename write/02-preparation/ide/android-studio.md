---
title: Android Studio Setup for Dart
subtitle: Konfigurasi Android Studio untuk pengembangan Dart dan Flutter
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - IDE Setup
  - Android Studio
pagination:
  prev_title: VS Code
  prev_url: /02-preparation/ide/vscode
  next_title: IntelliJ IDEA
  next_url: /02-preparation/ide/intellij-idea
---

Android Studio adalah IDE resmi Google untuk pengembangan Android, berbasis IntelliJ IDEA. Dengan plugin Dart dan Flutter, Android Studio menjadi pilihan utama untuk pengembangan aplikasi mobile.

### Instalasi Android Studio

1. Unduh dari [developer.android.com/studio](https://developer.android.com/studio)
2. Jalankan installer dan ikuti wizard
3. Pastikan komponen berikut tercentang saat instalasi:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

### Instalasi Plugin Dart & Flutter

1. Buka Android Studio
2. Pilih **File → Settings** (Windows/Linux) atau **Android Studio → Preferences** (macOS)
3. Navigasi ke **Plugins**
4. Cari dan install plugin berikut:
   - **Dart** — oleh JetBrains
   - **Flutter** — oleh JetBrains (otomatis menginstal Dart juga)
5. Restart IDE setelah instalasi

### Konfigurasi SDK Path

Setelah plugin terinstal, pastikan SDK path terdeteksi:

```bash:terminal.sh
# Cek lokasi Dart SDK
where dart        # Windows
which dart        # macOS/Linux

# Cek lokasi Flutter SDK (jika terinstal)
where flutter     # Windows
which flutter     # macOS/Linux
```

### Membuat Project Flutter

```bash:terminal.sh
# Via File → New → New Flutter Project
# Pilih Flutter
# Isi project name dan lokasi
# Klik Finish

# Atau via terminal
flutter create my_flutter_app
```

### Fitur Utama Android Studio

| Fitur | Kegunaan |
|-------|----------|
| **Emulator Manager** | Menjalankan dan mengelola Android Virtual Devices |
| **Flutter Inspector** | Visualisasi widget tree untuk debugging UI |
| **Flutter Outline** | Struktur widget dalam panel terpisah |
| **Hot Reload** | Tombol petir di toolbar — menerapkan perubahan kode tanpa restart |
| **Logcat** | Memonitor log aplikasi secara real-time |
| **Layout Inspector** | Inspeksi layout Android native |
| **Device File Explorer** | Akses file system perangkat/emulator |
| **Database Inspector** | Query dan modifikasi database langsung |

### Shortcut Penting

| Shortcut | Aksi |
|----------|------|
| `Ctrl+Shift+A` | Find Action (pencarian universal) |
| `Alt+Enter` | Quick Fix / Intention Actions |
| `Shift+F10` | Run |
| `Shift+F9` | Debug |
| `Ctrl+F2` | Stop |
| `Ctrl+Alt+L` | Reformat Code |
| `Ctrl+Q` | Quick Documentation |
| `Ctrl+B` | Go to Declaration |

### Konfigurasi Emulator

1. Buka **AVD Manager** dari toolbar
2. Klik **Create Virtual Device**
3. Pilih device (misal: Pixel 7)
4. Pilih system image (rekomendasi: API 34+)
5. Klik **Finish**

```bash:terminal.sh
# Jalankan emulator dari terminal
flutter emulators
flutter emulators --launch <emulator_id>

# Jalankan aplikasi
flutter run
```

### Kelebihan Android Studio untuk Dart/Flutter

- **All-in-one** — Android SDK, emulator, dan tools dalam satu IDE
- **Integrasi native** — Build konfigurasi Android dan iOS langsung
- **Profiling tools** — CPU, memory, dan network profiler
- **Visual debugging** — Flutter Inspector dan Layout Inspector