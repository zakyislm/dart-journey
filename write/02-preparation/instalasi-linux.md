---
title: Installing Dart on Linux
subtitle: Panduan langkah demi langkah instalasi Dart SDK pada distribusi Linux (Debian/Ubuntu, Fedora, Arch)
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - Instalasi Linux
pagination:
  prev_title: Instalasi macOS
  prev_url: /02-preparation/instalasi-macos
  next_title: IDE Setup
  next_url: /02-preparation/ide/index
---

Dart SDK tersedia melalui berbagai package manager Linux. Halaman ini mencakup instalasi untuk Debian/Ubuntu (APT), Fedora (DNF), dan Arch Linux (AUR), serta instalasi manual.

### Debian / Ubuntu (APT)

Google menyediakan repository APT resmi untuk distribusi berbasis Debian.

```bash:terminal.sh
# Tambahkan Google repository key
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg

# Tambahkan repository
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
  | sudo tee /etc/apt/sources.list.d/dart_stable.list

# Update dan install
sudo apt update
sudo apt install dart

# Verifikasi
dart --version
```

### Output

```text:output.txt
dart --version
Dart SDK version: 3.5.0 (stable) (Tue Aug 6 10:00:00 2024 +0000) on "linux_x64"
```

### Fedora / RHEL (DNF)

```bash:terminal.sh
# Tambahkan repository
sudo dnf config-manager --add-repo \
  https://storage.googleapis.com/download.dartlang.org/linux/fedora/dart_stable.repo

# Install
sudo dnf install dart

# Verifikasi
dart --version
```

### Arch Linux (AUR)

```bash:terminal.sh
# Menggunakan yay atau pacman wrapper AUR lain
yay -S dart-sdk

# Verifikasi
dart --version
```

### Instalasi Manual (Semua Distribusi)

```bash:terminal.sh
# 1. Download SDK sesuai arsitektur
#    x64: https://dart.dev/get-dart/archive -> dart-sdk-linux-x64.zip
#    ARM64: dart-sdk-linux-arm64.zip

# 2. Ekstrak ke direktori permanen
unzip ~/Downloads/dart-sdk-linux-x64.zip -d ~/development

# 3. Tambahkan ke PATH (tambahkan ke ~/.bashrc atau ~/.zshrc)
echo 'export PATH="$PATH:~/development/dart-sdk/bin"' >> ~/.bashrc
source ~/.bashrc

# 4. Verifikasi
dart --version
```

### Uji Coba

```bash:terminal.sh
cat > test.dart << 'EOF'
void main() {
  print('Dart di Linux berjalan!');
  print('PID: ${ProcessInfo.currentRss}');
}
EOF

dart run test.dart
```

### Output

```text:output.txt
Dart di Linux berjalan!
PID: 12345678
```

### Konfigurasi PATH Pub Cache

```bash:terminal.sh
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Update Dart SDK

```bash:terminal.sh
# Debian/Ubuntu
sudo apt update && sudo apt upgrade dart

# Fedora
sudo dnf update dart

# Arch
yay -Syu dart-sdk
```

### Troubleshooting

**GPG key expired.** Download ulang signing key dari `https://dl-ssl.google.com/linux/linux_signing_key.pub` dan import ulang.

**Arsitektur ARM.** Jika menggunakan Raspberry Pi atau server ARM, gunakan arsip `arm64` atau `arm` sesuai arsitektur prosesor. Cek dengan `uname -m`.

**Library dependencies.** Beberapa fitur Dart memerlukan library sistem:

```bash:terminal.sh
# Debian/Ubuntu
sudo apt install libstdc++6 libglib2.0-0