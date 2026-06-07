---
title: Android Studio Setup for Dart
subtitle: Instalasi dan konfigurasi Android Studio untuk pengembangan Dart dan Flutter
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

Android Studio adalah IDE resmi Google untuk pengembangan Android. Dengan plugin Dart dan Flutter, Android Studio menjadi pilihan utama bagi developer yang membangun aplikasi mobile dengan Flutter.

### Instalasi Android Studio

```powershell:terminal.ps1
# Windows - via winget
winget install Google.AndroidStudio

# macOS - via Homebrew
brew install --cask android-studio

# Linux - via Snap
sudo snap install android-studio --classic

# Atau unduh dari: https://developer.android.com/studio
```

### Setup Awal

Setelah instalasi, buka Android Studio dan ikuti wizard setup:

1. Pilih "Do not import settings" untuk instalasi bersih
2. Pilih "Standard" setup type
3. Pilih tema UI (Light/Dark)
4. Download SDK components yang direkomendasikan

### Instalasi Plugin Dart & Flutter

Buka **File > Settings > Plugins** (`Ctrl+Alt+S`):

1. Buka tab **Marketplace**
2. Cari "Dart" dan klik **Install**
3. Cari "Flutter" dan klik **Install**
4. Restart Android Studio

Plugin Dart akan otomatis terinstal bersama Flutter jika Anda memilih untuk menginstal Flutter terlebih dahulu.

### Konfigurasi Flutter SDK

Setelah plugin Flutter terinstal:

1. Buka **File > Settings > Languages & Frameworks > Flutter**
2. Masukkan path ke Flutter SDK (contoh: `C:\flutter` atau `~/development/flutter`)
3. Klik **Apply**

### Membuat Proyek Baru

**File > New > New Flutter Project** — pilih tipe proyek:

| Tipe | Deskripsi |
|------|-----------|
| Flutter Application | Aplikasi mobile/web/desktop dengan UI |
| Flutter Plugin | Plugin untuk platform-specific API |
| Flutter Package | Library Dart murni (shared code) |
| Dart Package | Library Dart tanpa Flutter dependency |

### Fitur Utama

**Android Emulator.** Android Studio menyediakan AVD (Android Virtual Device) Manager untuk membuat dan menjalankan emulator langsung dari IDE.

**Device Manager.** Pilih target device (emulator, USB device, web) dari toolbar.

**Widget Inspector.** Inspeksi widget tree Flutter secara visual — sangat membantu untuk debugging UI.

**Logcat.** Monitor log Android real-time untuk debugging platform-specific.

### Shortcuts Penting

| Shortcut | Aksi |
|----------|------|
| `Ctrl+Shift+F10` | Run |
| `Ctrl+F9` | Build project |
| `Alt+Enter` | Quick fix |
| `Ctrl+N` | Go to class |
| `Ctrl+Shift+N` | Go to file |
| `Shift+F6` | Rename |
| `Ctrl+Alt+L` | Reformat code |