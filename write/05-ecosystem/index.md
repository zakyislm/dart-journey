---
title: Dart Ecosystem
subtitle: Pub, pub.dev, project structure, dependencies, dan tooling di ekosistem Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Ekosistem
pagination:
  prev_title: Asynchronous
  prev_url: /04-oop-and-advanced/asynchronous
---

Bab ini mencakup ekosistem pengembangan Dart: package manager `pub`, repositori `pub.dev`, struktur project, manajemen dependencies, dan tooling CLI.

### Struktur Project Dart

```
my_app/
├── pubspec.yaml          # Manifest project (wajib)
├── pubspec.lock          # Lock file dependencies (auto-generated)
├── lib/                  # Source code utama
│   ├── src/              # Internal implementation
│   └── main.dart         # Entry point untuk standalone
├── bin/                  # CLI executables
├── test/                 # Unit tests
├── web/                  # Web assets (jika web app)
└── README.md
```

### pubspec.yaml — Manifest Project

```yaml:config.yaml
name: my_app
description: Aplikasi contoh Dart
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  http: ^1.1.0
  json_annotation: ^4.8.0

dev_dependencies:
  test: ^1.24.0
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
```

### Perintah Dasar CLI

```bash:terminal.sh
# Membuat project baru
dart create my_app

# Clone template project
dart create --template console-full my_cli_app
dart create --template web-simple my_web_app

# Menjalankan program
dart run lib/main.dart

# Compile ke executable
dart compile exe bin/my_app.dart

# Menambahkan dependency
dart pub add http
dart pub add dev:test          # Dev dependency

# Install/memperbarui dependencies
dart pub get

# Upgrade dependencies ke versi terbaru
dart pub upgrade

# Jalankan tests
dart test

# Format code
dart format lib/

# Static analysis (lint)
dart analyze

# Generate documentation
dart doc
```

### pub.dev — Package Registry

[pub.dev](https://pub.dev) adalah repositori resmi untuk package Dart dan Flutter. Package populer:

| Package | Kegunaan |
|---------|----------|
| `http` | HTTP client untuk REST API |
| `dio` | HTTP client dengan interceptors, retry, dll |
| `json_serializable` | Code generation JSON serialization |
| `freezed` | Immutable data classes |
| `riverpod` | State management |
| `dart_frog` | Backend framework |
| `shelf` | Web server middleware |
| `test` | Unit testing framework |

### Dependency Version Constraints

```yaml:config.yaml
# Di pubspec.yaml
dependencies:
  # Versi persis
  package_a: 1.0.0

  # Range versi (>=2.0.0 <3.0.0)
  package_b: ^2.0.0

  # Versi minimum
  package_c: '>=1.5.0'

  # Dari git
  package_d:
    git:
      url: https://github.com/user/repo.git
      ref: main

  # Dari path lokal
  package_e:
    path: ../local_package

# Dependency overrides (hati-hati)
dependency_overrides:
  package_a: 2.0.0  # Paksa versi
```

### Dart Compilation Targets

| Target | Command | Output |
|--------|---------|--------|
| Development | `dart run` | JIT (Just-in-Time) |
| Native executable | `dart compile exe` | AOT native binary |
| JavaScript | `dart compile js` | JS untuk web |
| Kernel | `dart compile kernel` | `.dill` intermediate |
| AOT snapshot | `dart compile aot-snapshot` | Fast startup |

### Analysis Options (Linting)

```yaml:config.yaml
# analysis_options.yaml
analyzer:
  strong-mode: true
  errors:
    missing_return: error
    dead_code: warning

linter:
  rules:
    - always_declare_return_types
    - prefer_const_constructors
    - avoid_print
    - require_trailing_commas
```

### Packages vs Plugins

| Istilah | Definisi |
|---------|----------|
| **Package** | Kode Dart murni — bisa dipakai di semua platform |
| **Plugin** | Package yang mengandung native code (Java/Kotlin untuk Android, Swift/Obj-C untuk iOS) |