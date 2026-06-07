---
title: IntelliJ IDEA Setup for Dart
subtitle: Konfigurasi IntelliJ IDEA untuk pengembangan Dart profesional
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - IDE Setup
  - IntelliJ IDEA
pagination:
  prev_title: Android Studio
  prev_url: /02-preparation/ide/android-studio
  next_title: Fundamental
  next_url: /03-fundamentals/index
---

IntelliJ IDEA adalah IDE flagship JetBrains yang menawarkan fitur code analysis, refactoring, dan navigation paling advanced. Tersedia dalam edisi **Community** (gratis) dan **Ultimate** (berbayar).

### Instalasi IntelliJ IDEA

1. Unduh dari [jetbrains.com/idea/download](https://www.jetbrains.com/idea/download/)
2. **Community Edition** — cukup untuk pengembangan Dart dasar
3. **Ultimate Edition** — fitur lengkap termasuk web development tools
4. Jalankan installer dan ikuti wizard

### Instalasi Plugin Dart

1. Buka IntelliJ IDEA
2. Pilih **File → Settings** (Windows/Linux) atau **IntelliJ IDEA → Preferences** (macOS)
3. Navigasi ke **Plugins → Marketplace**
4. Cari "Dart" — oleh JetBrains
5. Klik **Install** lalu **Restart IDE**

Plugin Dart otomatis menyediakan:

| Fitur | Deskripsi |
|-------|-----------|
| Syntax highlighting | Highlighting cerdas dengan semantic analysis |
| Code completion | Auto-complete dengan type inference |
| Real-time analysis | Error dan warning muncul saat mengetik |
| Refactoring | Rename, extract method, inline variable, dll |
| Navigation | Go to definition, find usages, type hierarchy |
| Debugging | Breakpoint, step through, variable inspection |
| Code formatting | `dart format` terintegrasi |

### Konfigurasi Dart SDK

```text:settings.txt
File → Settings → Languages & Frameworks → Dart

✓ Enable Dart support
  Dart SDK path: C:\tools\dart-sdk (atau lokasi instalasi Anda)
  ✓ Enable Dart support for the project
```

### Membuat Project Dart

```bash:terminal.sh
# Via File → New → Project
# Pilih Dart di panel kiri
# Isi Project name dan lokasi
# Pilih Dart SDK
# Klik Create

# Atau via terminal
dart create my_project
# Lalu buka folder my_project di IntelliJ (File → Open)
```

### Fitur Advanced JetBrains

| Fitur | Keterangan |
|-------|------------|
| **Structural Search** | Pencarian berdasarkan pattern kode, bukan teks |
| **Intention Actions** | Alt+Enter — saran perbaikan kontekstual |
| **Code Inspections** | Ratusan aturan analisis statis |
| **Live Templates** | Template kode yang bisa dikustomisasi |
| **Local History** | Version control lokal tanpa Git |
| **Run Configurations** | Konfigurasi run/debug yang fleksibel |
| **Version Control** | Integrasi Git, GitHub, GitLab, Mercurial |
| **Terminal Built-in** | Terminal terintegrasi dengan path SDK |

### Shortcut Utama (Keymap Default — Windows/Linux)

| Shortcut | Aksi |
|----------|------|
| `Ctrl+Shift+A` | Find Action |
| `Double Shift` | Search Everywhere |
| `Alt+Enter` | Show Context Actions |
| `Ctrl+Shift+F10` | Run |
| `Shift+F9` | Debug |
| `Ctrl+Alt+L` | Reformat Code |
| `Ctrl+Alt+O` | Optimize Imports |
| `Shift+F6` | Rename (refactoring) |
| `Ctrl+Q` | Quick Documentation |
| `Ctrl+P` | Parameter Info |
| `Ctrl+Shift+Space` | Smart Code Completion |
| `Ctrl+F12` | File Structure |

### Perbandingan Edisi

| Aspek | Community | Ultimate |
|-------|-----------|----------|
| Dart/Flutter | ✔ | ✔ |
| Java/Kotlin | ✔ | ✔ |
| Spring Boot | ✘ | ✔ |
| JavaScript/TypeScript | ✘ | ✔ |
| Database Tools | ✘ | ✔ |
| Profiler | ✘ | ✔ |
| Harga | Gratis | Mulai \$16.90/bln |

### Rekomendasi

- **Dart/Flutter only** — Community Edition sudah mencukupi
- **Full-stack dengan backend** — Ultimate Edition untuk database dan web tools
- **Mahasiswa/Open-source** — Ultimate gratis melalui [JetBrains Student Pack](https://www.jetbrains.com/community/education/#students)