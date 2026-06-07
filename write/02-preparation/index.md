---
title: Development Environment Setup
subtitle: Instalasi Dart SDK dan konfigurasi IDE untuk memulai pengembangan
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
pagination:
  prev_title: Pengenalan
  prev_url: /01-introduction/index
  next_title: Instalasi Windows
  next_url: /02-preparation/instalasi-windows
---

Bab ini memandu Anda melalui instalasi Dart SDK di berbagai sistem operasi dan konfigurasi IDE/editor untuk pengembangan yang produktif.

### Persiapan Minimum

Untuk memulai pengembangan Dart, Anda memerlukan:

| Komponen | Minimum | Direkomendasikan |
|----------|---------|------------------|
| OS | Windows 10+, macOS 11+, Linux (kernel 4+) | Versi terbaru masing-masing OS |
| RAM | 4 GB | 8 GB atau lebih |
| Disk | 2 GB | SSD dengan 10 GB tersisa |
| Dart SDK | 3.0+ | 3.5+ (stable) |
| IDE | VS Code / IntelliJ / Android Studio | VS Code (ringan) untuk pemula |

### Alur Persiapan

Langkah-langkah yang direkomendasikan:

1. **Pilih sistem operasi** — Buka halaman instalasi sesuai OS Anda: Windows, macOS, atau Linux
2. **Install Dart SDK** — Ikuti panduan instalasi untuk package manager atau manual
3. **Verifikasi instalasi** — Jalankan `dart --version` di terminal
4. **Pilih IDE** — VS Code (ringan), Android Studio (mobile), atau IntelliJ IDEA (JetBrains)
5. **Install plugin Dart** — Syntax highlighting, debugging, dan IntelliSense
6. **Buat proyek pertama** — `dart create hello_world`

### Verifikasi Instalasi

Setelah SDK terinstal, jalankan perintah berikut untuk memverifikasi:

```bash:terminal.sh
# Cek versi SDK
dart --version

# Cek konfigurasi
dart info

# Jalankan DartPad versi CLI
dart run
```

### Output (contoh)

```
dart --version
Dart SDK version: 3.5.0 (stable) on "windows_x64"

dart info
Dart SDK: 3.5.0
Pub: 3.5.0
OS: Windows 10 (10.0.22631)
```

### Proyek Pertama

Setelah instalasi lengkap, buat dan jalankan proyek pertama:

```powershell:terminal.ps1
dart create hello_dart
cd hello_dart
dart run
```

### Output

```text:output.txt
Hello world: hello_dart!
```

### Navigasi Bab Ini

- [Instalasi Windows](/02-preparation/instalasi-windows) — Chocolatey, winget, atau ZIP
- [Instalasi macOS](/02-preparation/instalasi-macos) — Homebrew atau manual
- [Instalasi Linux](/02-preparation/instalasi-linux) — APT, DNF, AUR, atau manual
- [IDE Setup](/02-preparation/ide/index) — Perbandingan IDE dan editor
- [VS Code](/02-preparation/ide/vscode) — Setup VS Code untuk Dart
- [Android Studio](/02-preparation/ide/android-studio) — Setup Android Studio
- [IntelliJ IDEA](/02-preparation/ide/intellij-idea) — Setup IntelliJ IDEA