---
title: Installing Dart on Windows
subtitle: Panduan langkah demi langkah instalasi Dart SDK pada sistem operasi Windows
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - Instalasi Windows
pagination:
  prev_title: Persiapan
  prev_url: /02-preparation/index
  next_title: Instalasi macOS
  next_url: /02-preparation/instalasi-macos
---

Terdapat tiga metode untuk menginstal Dart SDK di Windows: melalui installer resmi (`choco`), manual dari arsip ZIP, atau melalui package manager `winget`.

### Metode 1: Chocolatey (Direkomendasikan)

Chocolatey adalah package manager untuk Windows yang memudahkan instalasi dan update.

```powershell:terminal.ps1
# Install Chocolatey terlebih dahulu (jalankan PowerShell sebagai Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Dart SDK
choco install dart-sdk

# Verifikasi instalasi
dart --version
```

### Output

```text:output.txt
dart --version
Dart SDK version: 3.5.0 (stable) (Tue Aug 6 10:00:00 2024 +0000) on "windows_x64"
```

### Metode 2: Instalasi Manual (ZIP)

Unduh arsip ZIP dari situs resmi dan ekstrak secara manual.

```powershell:terminal.ps1
# 1. Buka https://dart.dev/get-dart
# 2. Download dart-sdk-windows-x64.zip
# 3. Ekstrak ke direktori permanen, misalnya:
#    C:\tools\dart-sdk

# 4. Tambahkan ke PATH (PowerShell Administrator):
[Environment]::SetEnvironmentVariable(
  "Path",
  [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\tools\dart-sdk\bin",
  "User"
)

# 5. Restart terminal dan verifikasi
dart --version
```

### Metode 3: Winget (Windows Package Manager)

```powershell:terminal.ps1
# Install Dart melalui winget
winget install DartLang.DartSDK

# Verifikasi
dart --version
```

### Verifikasi dan Uji Coba

Setelah instalasi berhasil, jalankan program sederhana untuk memastikan semuanya berfungsi:

```powershell:terminal.ps1
# Membuat file test
echo "void main() { print('Dart di Windows berjalan!'); }" > test.dart

# Menjalankan
dart run test.dart
```

### Output

```text:output.txt
Dart di Windows berjalan!
```

### Konfigurasi PATH Tambahan

Pastikan direktori `%APPDATA%\Pub\Cache\bin` juga ditambahkan ke PATH environment variable, karena package Dart yang memiliki executable akan diinstal di sini:

```powershell:terminal.ps1
# Cek lokasi pub cache
dart pub cache list

# Tambahkan ke PATH jika belum ada
# %APPDATA%\Pub\Cache\bin
# Contoh: C:\Users\<username>\AppData\Local\Pub\Cache\bin
```

### Update Dart SDK

```powershell:terminal.ps1
# Melalui Chocolatey
choco upgrade dart-sdk

# Atau unduh versi terbaru dan ekstrak ulang untuk instalasi manual
```

### Troubleshooting Umum

**Error: 'dart' is not recognized.** Pastikan direktori `dart-sdk\bin` sudah ditambahkan ke PATH dan terminal sudah direstart.

**Error: Cannot find SDK.** Jalankan `where dart` untuk melihat lokasi eksekusi dart. Jika ada beberapa instalasi, pastikan PATH menunjuk ke versi yang benar.

**Permission denied.** Jalankan PowerShell sebagai Administrator untuk operasi yang memerlukan akses sistem.