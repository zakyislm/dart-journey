---
title: Installing Dart on macOS
subtitle: Panduan langkah demi langkah instalasi Dart SDK pada sistem operasi macOS
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - Instalasi macOS
pagination:
  prev_title: Instalasi Windows
  prev_url: /02-preparation/instalasi-windows
  next_title: Instalasi Linux
  next_url: /02-preparation/instalasi-linux
---

Instalasi Dart di macOS dapat dilakukan melalui Homebrew (direkomendasikan) atau instalasi manual dari arsip ZIP. Homebrew memudahkan update dan manajemen versi.

### Metode 1: Homebrew (Direkomendasikan)

Homebrew adalah package manager standar untuk macOS.

```bash:terminal.sh
# Install Homebrew jika belum ada
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Dart SDK
brew install dart

# Verifikasi instalasi
dart --version
```

### Output

```text:output.txt
dart --version
Dart SDK version: 3.5.0 (stable) (Tue Aug 6 10:00:00 2024 +0000) on "macos_arm64"
```

### Metode 2: Instalasi Manual (ZIP)

```bash:terminal.sh
# 1. Buka https://dart.dev/get-dart
# 2. Download sesuai arsitektur:
#    - Apple Silicon (M1/M2/M3): dart-sdk-macos-arm64.zip
#    - Intel: dart-sdk-macos-x64.zip

# 3. Ekstrak dan pindahkan ke direktori permanen
unzip ~/Downloads/dart-sdk-macos-arm64.zip -d ~/development
# atau untuk Intel:
# unzip ~/Downloads/dart-sdk-macos-x64.zip -d ~/development

# 4. Tambahkan ke PATH (tambahkan ke ~/.zshrc atau ~/.bash_profile)
echo 'export PATH="$PATH:~/development/dart-sdk/bin"' >> ~/.zshrc
source ~/.zshrc

# 5. Verifikasi
dart --version
```

### Uji Coba

```bash:terminal.sh
# Buat file test
cat > test.dart << 'EOF'
void main() {
  print('Dart di macOS berjalan!');
  print('Arsitektur: ${Platform.operatingSystem}');
}
EOF

# Jalankan
dart run test.dart
```

### Output

```text:output.txt
Dart di macOS berjalan!
Arsitektur: macos
```

### Konfigurasi Pub Cache PATH

```bash:terminal.sh
# Tambahkan pub cache bin ke PATH
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Update Dart SDK

```bash:terminal.sh
# Melalui Homebrew
brew update
brew upgrade dart

# Cek versi terbaru
dart --version
```

### Troubleshooting

**Rosetta vs Native ARM.** Jika menggunakan Mac Apple Silicon, pastikan Anda mengunduh versi `arm64`. Versi `x64` tetap berjalan melalui Rosetta 2 namun dengan performa lebih rendah.

**Xcode Command Line Tools.** Beberapa fitur `dart:ffi` memerlukan Xcode CLI tools:

```bash:terminal.sh
xcode-select --install
```

**Permission denied saat brew.** Jalankan `brew doctor` untuk diagnosis dan perbaikan otomatis.