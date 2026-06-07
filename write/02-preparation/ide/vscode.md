---
title: VS Code Setup for Dart
subtitle: Instalasi, konfigurasi, dan ekstensi Visual Studio Code untuk pengembangan Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Persiapan
  - IDE Setup
  - VS Code
pagination:
  prev_title: IDE Setup
  prev_url: /02-preparation/ide/index
  next_title: Android Studio
  next_url: /02-preparation/ide/android-studio
---

Visual Studio Code adalah editor paling populer untuk pengembangan Dart, terutama dengan Flutter. Ringan, cepat, dan memiliki ekstensi resmi Dart yang terus diperbarui oleh tim Google.

### Instalasi VS Code

```powershell:terminal.ps1
# Windows - via winget
winget install Microsoft.VisualStudioCode

# macOS - via Homebrew
brew install --cask visual-studio-code

# Linux - via Snap
sudo snap install code --classic

# Atau unduh dari: https://code.visualstudio.com
```

### Instalasi Ekstensi Dart

Buka VS Code, masuk ke panel Extensions (`Ctrl+Shift+X`), dan install:

| Ekstensi | Publisher | Fungsi |
|----------|-----------|--------|
| **Dart** | Dart Code | Syntax highlighting, code completion, debugging, hot reload |
| **Flutter** | Dart Code | Flutter-specific tools (widget inspector, device manager, emulator) |
| **Pubspec Assist** | Jesus Rodriguez | Auto-complete dan validasi pubspec.yaml |

```powershell:terminal.ps1
# Atau via CLI
code --install-extension dart-code.dart-code
code --install-extension dart-code.flutter
code --install-extension jesus-rodriguez.pubspec-assist
```

### Konfigurasi settings.json

```jsonc:settings.json
{
  // Dart-specific settings
  "dart.debugExternalPackageLibraries": false,
  "dart.debugSdkLibraries": false,
  "dart.showTodos": true,
  "dart.lineLength": 80,
  "dart.previewFlutterUiGuides": true,

  // Format on save
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },

  // Dart formatter sebagai default untuk file .dart
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.formatOnSave": true,
    "editor.tabSize": 2,
    "editor.rulers": [80]
  },

  // Closing labels untuk nested function/class
  "dart.closingLabels": true,
  "dart.previewLsp": true
}
```

### Fitur Penting

**Code Completion.** Dart extension menyediakan IntelliSense yang kontekstual — parameter hints, import otomatis, dan dokumentasi inline saat hover.

**Debugging.** Set breakpoint, step through code, dan inspect variable values langsung di editor. Tekan `F5` untuk memulai debugging.

**Static Analysis.** Error ditampilkan real-time di Problems panel. Proyek Dart dianalisis otomatis setiap kali file disimpan.

**Code Actions.** Tekan `Ctrl+.` pada kode yang bermasalah untuk melihat saran perbaikan otomatis. Contohnya: ekstrak method, convert ke async, wrap dengan widget.

### Shortcuts Penting

| Shortcut | Aksi |
|----------|------|
| `F5` | Start debugging |
| `Ctrl+F5` | Run without debugging |
| `Ctrl+.` | Quick fix / code actions |
| `Ctrl+Shift+O` | Go to symbol in file |
| `F12` | Go to definition |
| `Shift+F12` | Find all references |
| `F2` | Rename symbol |
| `Ctrl+K Ctrl+C` | Comment line |
| `Ctrl+K Ctrl+U` | Uncomment line |

### Proyek Dart Baru di VS Code

```powershell:terminal.ps1
# 1. Buka Command Palette (Ctrl+Shift+P)
# 2. Pilih "Dart: New Project"
# 3. Pilih template:
#    - Console Application (CLI)
#    - Dart Package (library)
#    - Web Application

# 4. Pilih direktori dan beri nama proyek

# 5. Atau via terminal:
dart create my_dart_project
code my_dart_project
```

### Output

Setelah proyek dibuat, struktur file akan tampil di Explorer. Jalankan dengan `F5` untuk memulai debugging, atau `Ctrl+F5` untuk run tanpa debugging.