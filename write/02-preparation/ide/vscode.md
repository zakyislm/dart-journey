---
title: VS Code Setup for Dart
subtitle: Konfigurasi Visual Studio Code untuk pengembangan Dart yang produktif
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

Visual Studio Code (VS Code) adalah editor kode ringan dari Microsoft yang menjadi pilihan populer untuk pengembangan Dart dan Flutter. Dengan extension resmi Dart, Anda mendapatkan syntax highlighting, IntelliSense, debugging, dan hot reload.

### Instalasi VS Code

Unduh dan instal VS Code dari [code.visualstudio.com](https://code.visualstudio.com/). Tersedia untuk Windows, macOS, dan Linux.

### Instalasi Extension Dart

1. Buka VS Code
2. Klik icon Extensions di sidebar kiri (atau tekan `Ctrl+Shift+X`)
3. Cari "Dart" — pastikan extension dari **Dart Code** (verified publisher)
4. Klik **Install**

Extension Dart otomatis menginstal dependency berikut:

| Extension | Fungsi |
|-----------|--------|
| **Dart** | Syntax highlighting, IntelliSense, debugging, code completion |
| **Flutter** | Hot reload, widget inspector, Flutter outline (otomatis terinstal jika Flutter terdeteksi) |

### Konfigurasi settings.json

```json:settings.json
{
  // Dart & Flutter
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.sdkPath": "/path/to/dart-sdk",

  // Auto-format on save
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit"
  },

  // Line length guide (Dart convention: 80 chars)
  "dart.lineLength": 80,

  // Closing labels untuk nested widgets
  "dart.closingLabels": true,

  // Preview Flutter UI guides
  "dart.previewFlutterUiGuides": true,

  // Show todos in Problems panel
  "dart.showTodos": true
}
```

### Shortcut Penting

| Shortcut | Aksi |
|----------|------|
| `Ctrl+Shift+P` | Command Palette |
| `Ctrl+.` | Quick Fix / Code Actions |
| `F5` | Start debugging |
| `Ctrl+F5` | Run without debugging |
| `Shift+Alt+F` | Format document |
| `F12` | Go to Definition |
| `Ctrl+K Ctrl+C` | Comment line |
| `Alt+Up/Down` | Move line |

### Membuat dan Menjalankan Project

Setelah extension terinstal, buat project Dart baru:

```bash:terminal.sh
# Melalui Command Palette (Ctrl+Shift+P)
# Ketik: Dart: New Project
# Pilih: Console Application

# Atau via terminal di VS Code (Ctrl+`)
dart create my_app
cd my_app
dart run
```

### Debugging di VS Code

VS Code mendukung debugging Dart secara native. Breakpoint dapat dipasang dengan klik di samping nomor baris. Tekan `F5` untuk mulai debugging.

```dart:debug_example.dart
void main() {
  var numbers = [1, 2, 3, 4, 5];
  var sum = 0;

  for (var n in numbers) {
    sum += n;  // Pasang breakpoint di sini
  }

  print('Total: $sum');
}
```

### Extension Tambahan yang Direkomendasikan

| Extension | Fungsi |
|-----------|--------|
| **Error Lens** | Menampilkan error dan warning inline |
| **CodeSnap** | Screenshot kode dengan styling |
| **Better Comments** | Highlight jenis komentar berbeda |
| **GitLens** | Git blame, history, dan visualisasi |
| **Material Icon Theme** | Icon tema untuk file explorer |