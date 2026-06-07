---
title: IntelliJ IDEA Setup for Dart
subtitle: Konfigurasi JetBrains IntelliJ IDEA untuk pengembangan Dart
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

IntelliJ IDEA (Community atau Ultimate) dari JetBrains memberikan pengalaman pengembangan Dart yang matang, terutama bagi developer yang sudah familiar dengan ekosistem JetBrains (Java, Kotlin, Python).

### Instalasi IntelliJ IDEA

```powershell:terminal.ps1
# Windows - via winget
winget install JetBrains.IntelliJIDEA.Community

# macOS - via Homebrew
brew install --cask intellij-idea-ce

# Linux - via Snap
sudo snap install intellij-idea-community --classic

# Atau unduh dari: https://www.jetbrains.com/idea/download
```

### Perbedaan Community vs Ultimate

| Fitur | Community | Ultimate |
|-------|-----------|----------|
| Plugin Dart | Ya | Ya |
| Plugin Flutter | Ya | Ya |
| Web development | Terbatas | Penuh (HTML, CSS, JS) |
| Database tools | Tidak | Ya |
| Framework support | Terbatas | Spring, Jakarta, Micronaut |
| Biaya | Gratis | Berbayar |

Untuk pengembangan Dart murni, **Community Edition sudah mencukupi**.

### Instalasi Plugin Dart

Buka **File > Settings > Plugins** (`Ctrl+Alt+S`):

1. Buka tab **Marketplace**
2. Cari "Dart" — publisher **JetBrains**
3. Klik **Install**
4. Restart IDE

Plugin Flutter akan otomatis menginstal plugin Dart sebagai dependency.

### Konfigurasi Dart SDK

Setelah plugin terinstal:

1. Buka **File > Settings > Languages & Frameworks > Dart**
2. Centang "Enable Dart support"
3. Masukkan path ke Dart SDK (terdeteksi otomatis jika di PATH)
4. Klik **Apply**

### Membuat Proyek Dart

**File > New > Project**:

1. Pilih **Dart** dari daftar generator
2. Pilih template: Console Application, Web Server, atau Package
3. Tentukan nama dan lokasi proyek
4. Pilih Dart SDK version
5. Klik **Create**

### Fitur Eksklusif IntelliJ

**Refactoring.** IntelliJ memiliki engine refactoring paling canggih: extract method, inline variable, change signature, dan move class antar file.

**VCS Integration.** Git, GitHub, GitLab, Mercurial terintegrasi langsung dengan diff viewer yang powerful.

**Live Templates.** Potongan kode yang dapat dikustomisasi dengan shortcut. Contohnya, ketik `main` lalu `Tab` untuk generate fungsi `main()`.

```dart:example.dart
// Live template: psvm + Tab
void main() {

}

// Live template: iter + Tab
for (var item in collection) {

}
```

**Code Analysis.** Inspections yang lebih mendalam dibanding editor lain — mendeteksi dead code, unnecessary imports, dan potensi bug.

### Shortcuts Penting

| Shortcut | Aksi |
|----------|------|
| `Shift+F10` | Run |
| `Shift+F9` | Debug |
| `Alt+Enter` | Quick fix |
| `Ctrl+N` | Go to class |
| `Ctrl+Shift+N` | Go to file |
| `Ctrl+E` | Recent files |
| `Ctrl+Shift+A` | Find action |
| `Shift+F6` | Rename |
| `Ctrl+Alt+L` | Reformat code |