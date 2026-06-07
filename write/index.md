---
title: Complete Dart Programming Language Documentation
subtitle: Panduan komprehensif dari dasar hingga mahir — disusun untuk developer Indonesia
date: 06-07-2026
language: Dart
pagination:
  next_title: Pengenalan
  next_url: /01-introduction/index
---

Dart adalah bahasa pemrograman modern, berorientasi objek, dan **type-safe** yang dikembangkan oleh Google. Dirancang untuk membangun aplikasi **client-side** — mobile (Flutter), web, server, dan CLI — Dart menawarkan performa tinggi dengan sintaks yang ekspresif dan mudah dipelajari.

### Filosofi Dart

Dart dibangun dengan empat prinsip utama:

**Productive.** Sintaks deklaratif namun familier. Hot reload di Flutter memungkinkan iterasi cepat. Static analysis yang kuat menangkap error lebih awal.

**Portable.** Satu codebase dapat dikompilasi ke ARM/x64 machine code (native), atau JavaScript (web). Dart mendukung JIT (Just-in-Time) untuk development dan AOT (Ahead-of-Time) untuk production.

**Fast.** Garbage collector generational, SIMD, dan FFI untuk interoperabilitas dengan C/C++. Isolate memungkinkan parallelism sejati tanpa shared memory.

**Approachable.** Dokumentasi lengkap, toolchain sederhana, dan komunitas global yang aktif. DartPad memungkinkan eksperimen langsung tanpa instalasi.

### Cuplikan Kode Dasar

```dart:hello.dart
// Fungsi entry point — setiap program Dart dimulai dari main()
void main() {
  // Deklarasi variabel dengan tipe inference
  var nama = 'Dunia';
  final tahun = 2026;

  // String interpolation
  print('Halo, $nama! Selamat datang di $tahun.');

  // Anonymous function dengan arrow syntax
  var sapa = (String n) => 'Selamat belajar, $n!';
  print(sapa('Developer'));

  // Collection literal dengan spread & collection-if
  var keterampilan = ['Dart', 'Flutter', if (tahun > 2025) 'AI/ML'];
  print('Keterampilan: $keterampilan');

  // Null safety — compiler memastikan tidak ada null error
  String? mungkinNull;
  print(mungkinNull ?? 'Nilai default');
}
```

### Output

```text:output.txt
Halo, Dunia! Selamat datang di 2026.
Selamat belajar, Developer!
Keterampilan: [Dart, Flutter, AI/ML]
Nilai default
```

### Navigasi Dokumentasi

Dokumentasi ini disusun dalam lima bab utama yang saling terhubung. Setiap halaman dilengkapi navigasi previous/next untuk memudahkan pembacaan berurutan.

| Bab | Topik | Deskripsi |
|-----|-------|-----------|
| Pengenalan | Sejarah & Filosofi | Asal-usul Dart, evolusi versi, dan prinsip desain |
| Persiapan | Instalasi & IDE | Setup SDK Dart dan konfigurasi development environment |
| Fundamental | Variabel & Kontrol Alur | Sintaks dasar, tipe data, operator, percabangan, perulangan |
| OOP & Lanjutan | Object-Oriented & Async | Class, inheritance, mixins, null safety, Future, Stream |
| Ekosistem | Package & CLI | Pubspec, pub.dev, dart CLI, testing, dan deployment |

### Mengapa Dart?

Dart mengisi celah antara bahasa scripting dinamis (JavaScript, Python) dan bahasa sistem statis (C++, Rust). Dengan **sound null safety**, **strong typing dengan inference**, dan **multi-platform compilation**, Dart menjadi pilihan ideal untuk:

- **Flutter Developer** — Membangun UI native untuk iOS, Android, Web, dan Desktop
- **Backend Developer** — Web server dengan Shelf, Alfred, atau Serverpod
- **CLI Tooling** — Scripting dan automation dengan kompilasi native
- **Full-Stack Developer** — Satu bahasa untuk frontend dan backend

### Prasyarat

Tidak ada prasyarat ketat. Dokumentasi ini dirancang agar dapat diikuti oleh pemula yang memiliki pemahaman dasar logika pemrograman. Jika Anda sudah familiar dengan JavaScript, Java, atau C#, transisi ke Dart akan terasa natural.