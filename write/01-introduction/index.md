---
title: Introduction to Dart
subtitle: Sejarah, evolusi, dan filosofi bahasa pemrograman Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Pengenalan
pagination:
  prev_title: Home
  prev_url: /index
  next_title: Persiapan
  next_url: /02-preparation/index
---

Dart adalah bahasa pemrograman **general-purpose** yang dikembangkan oleh Google dan pertama kali diperkenalkan pada konferensi GOTO Aarhus, 10 Oktober 2011. Awalnya dirancang sebagai pengganti JavaScript di browser, Dart kini telah berevolusi menjadi bahasa multi-platform andalan — terutama sejak menjadi fondasi framework **Flutter** pada 2017.

### Sejarah Singkat

| Tahun | Milestone |
|-------|-----------|
| 2011 | Dart 0.1 dirilis di GOTO Conference — fokus sebagai bahasa web |
| 2013 | Dart 1.0 — versi stabil pertama dengan `dart2js` compiler |
| 2015 | Dartium (Chromium + Dart VM) dihentikan |
| 2017 | Flutter alpha — Dart menjadi bahasa utama pengembangan mobile |
| 2018 | Dart 2.0 — perubahan besar: strong type system, `new`/`const` opsional |
| 2019 | Dart 2.5 — `dart:ffi` untuk interoperabilitas C |
| 2020 | Dart 2.8 — null safety preview |
| 2021 | Dart 2.12 — sound null safety stabil; Flutter 2.0 (multi-platform) |
| 2022 | Dart 2.18 — `dart compile exe` untuk Windows/Linux/macOS |
| 2023 | Dart 3.0 — pattern matching, records, sealed class, switch expression |
| 2024 | Dart 3.4+ — macros preview, webAssembly compilation |
| 2025+ | Dart & Flutter terus berkembang bersama |

### Filosofi Desain

Dart dibangun di atas empat pilar yang ditetapkan oleh tim engineering Google:

**Productive.** Bahasa ini dirancang agar developer dapat menulis, membaca, dan memelihara kode secara efisien. Fitur seperti type inference (`var`, `final`), collection literals, dan string interpolation mengurangi boilerplate tanpa mengorbankan kejelasan.

**Portable.** Satu codebase Dart dapat dikompilasi ke berbagai target:

- **ARM/x64 machine code** — untuk mobile (iOS/Android) dan desktop
- **JavaScript** — untuk browser modern melalui `dart2js` atau `dart compile js`
- **WebAssembly** — target kompilasi baru untuk performa web native

**Fast.** Dart VM menggunakan:
- **JIT (Just-in-Time)** compiler — untuk development dengan hot reload
- **AOT (Ahead-of-Time)** compiler — untuk production dengan startup cepat
- **Generational garbage collector** — alokasi/dealokasi efisien untuk UI smooth

**Approachable.** Dart dipengaruhi oleh Java, JavaScript, C#, dan Smalltalk — sehingga developer dari berbagai latar belakang dapat belajar dengan cepat.

### Dart vs Bahasa Lain

| Aspek | Dart | JavaScript | Java | Kotlin |
|-------|------|------------|------|--------|
| Tipe sistem | Static + inference | Dynamic | Static | Static + inference |
| Null safety | Sound (compile-time) | Tidak native | Optional | Built-in |
| Concurrency | Isolate (no shared memory) | Worker threads | Threads (shared memory) | Coroutines |
| Kompilasi | JIT + AOT | JIT | JIT + AOT (GraalVM) | JVM + Native |
| Mobile framework | Flutter | React Native | Android SDK | Android + KMP |
| Entry point | `main()` top-level | Any script | `public static void main` | `fun main()` |

### Karakteristik Teknis

Dart adalah bahasa **berorientasi objek murni** dengan **class-based inheritance**. Setiap nilai adalah object — termasuk tipe primitif seperti `int`, `double`, dan `bool`. Semua class mewarisi dari `Object` (kecuali `Null`).

```dart:karakteristik.dart
void main() {
  // Semua nilai adalah object
  int angka = 42;
  print(angka is Object);       // true
  print(angka.runtimeType);     // int

  // Fungsi juga object — first-class citizen
  var fungsi = (int x) => x * 2;
  print(fungsi is Object);      // true
  print(fungsi(21));            // 42

  // Type inference — compiler menentukan tipe otomatis
  var nama = 'Dart';            // inferred as String
  final versi = 3.4;            // inferred as double
  const pi = 3.14159;           // compile-time constant

  // String interpolation
  print('Bahasa: $nama v$versi, PI = $pi');
}
```

### Output

```text:output.txt
true
int
true
42
Bahasa: Dart v3.4, PI = 3.14159
```

### Ekosistem Dart

Dart bukan hanya bahasa — melainkan platform lengkap:

- **Dart SDK** — compiler, analyzer, formatter, package manager (`dart pub`)
- **dart:core** — library built-in (collections, string, math, async)
- **dart:io** — akses file system, networking, processes
- **dart:isolate** — concurrency model
- **dart:ffi** — foreign function interface untuk C/C++
- **pub.dev** — registry paket dengan ribuan library open-source
- **DartPad** — playground online tanpa instalasi
- **Flutter** — UI framework untuk aplikasi multi-platform

### Kapan Menggunakan Dart

Dart ideal untuk:

- **Aplikasi mobile** — dengan Flutter, target iOS dan Android dari satu codebase
- **Aplikasi web** — kompilasi ke JavaScript atau WebAssembly
- **Aplikasi desktop** — Windows, macOS, Linux
- **Backend/server** — Shelf, Serverpod, dart_frog
- **CLI tools** — scripting dan automation dengan kompilasi native executable
- **Cross-platform library** — satu library untuk semua platform

Dart tidak ideal untuk:

- **Embedded systems** — meskipun bisa dengan AOT, belum menjadi target utama
- **Data science** — ekosistem library masih terbatas dibanding Python/R
- **Game development** — kecuali game sederhana 2D (Flame engine)