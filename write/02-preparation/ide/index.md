---
title: IDE & Editor Setup
subtitle: Konfigurasi development environment untuk Dart - VS Code, Android Studio, dan IntelliJ IDEA
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - IDE Setup
pagination:
  prev_title: Instalasi Linux
  prev_url: /02-preparation/instalasi-linux
  next_title: VS Code
  next_url: /02-preparation/ide/vscode
---

Dart didukung secara resmi di tiga IDE/editor utama: **Visual Studio Code**, **Android Studio**, dan **IntelliJ IDEA**. Masing-masing menyediakan plugin resmi Dart yang mencakup syntax highlighting, code completion, debugging, hot reload (Flutter), dan static analysis real-time.

### Perbandingan IDE

| Fitur | VS Code | Android Studio | IntelliJ IDEA |
|-------|---------|---------------|---------------|
| Platform | Windows, macOS, Linux | Windows, macOS, Linux | Windows, macOS, Linux |
| Berat | Ringan | Berat | Berat |
| Target utama | Dart + Flutter (universal) | Flutter + Android | Dart + Flutter + JVM |
| Plugin | `dart-code` | `dart` (bawaan saat install Flutter) | `dart` |
| Hot reload | Ya | Ya | Ya |
| Debugging | Ya | Ya | Ya |
| Device manager | Ya | Ya (Android Emulator terintegrasi) | Ya |
| Widget inspector | Ya | Ya | Ya |
| Performa | Sangat cepat | Cepat | Cepat |
| Biaya | Gratis | Gratis | Community (gratis) / Ultimate (berbayar) |

### Rekomendasi

- **Pemula**: VS Code — ringan, cepat, dan gratis.
- **Android Developer**: Android Studio — integrasi Android SDK dan Emulator paling mulus.
- **Full-stack (Java/Kotlin + Dart)**: IntelliJ IDEA Ultimate.

### Instalasi Plugin Dart

Semua IDE menggunakan plugin Dart yang sama dari JetBrains/Google. Pilih halaman sesuai IDE Anda untuk panduan instalasi dan konfigurasi.