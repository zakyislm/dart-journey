---
title: Variables & Data Types
subtitle: Deklarasi variabel, type inference, dan tipe data primitif di Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Variabel & Tipe Data
pagination:
  prev_title: Fundamental
  prev_url: /03-fundamentals/index
  next_title: Numbers
  next_url: /03-fundamentals/variabel/numbers
---

Dart adalah bahasa **statically typed** dengan **type inference**. Anda dapat mendeklarasikan tipe secara eksplisit atau membiarkan compiler menyimpulkannya. Dart 3 memperkenalkan **records** dan **patterns** yang memperluas sistem tipe.

### Deklarasi Variabel

Dart memiliki tiga keyword utama untuk deklarasi variabel:

| Keyword | Mutable | Inisialisasi | Keterangan |
|---------|---------|-------------|------------|
| `var` | Ya | Saat deklarasi atau nanti | Type inferred dari nilai pertama |
| `final` | Tidak | Sekali, bisa runtime | Lazily initialized |
| `const` | Tidak | Compile-time | Harus konstanta literal |

```dart:deklarasi.dart
void main() {
  // var — mutable, type inferred
  var nama = 'Budi';        // String
  var umur = 25;            // int
  nama = 'Ani';             // OK
  // nama = 30;             // Error: tidak bisa ubah tipe
  // var x;                 // Error: var harus diinisialisasi

  // final — immutable, bisa runtime
  final sekarang = DateTime.now();
  // sekarang = DateTime.now(); // Error: final tidak bisa diubah

  // const — immutable, compile-time
  const pi = 3.14159;
  const duaPi = pi * 2;     // Bisa operasi konstanta
  // const waktu = DateTime.now(); // Error: DateTime.now() bukan konstanta

  // Tipe eksplisit
  String kota = 'Jakarta';
  int tahun = 2026;
  double suhu = 28.5;
  bool aktif = true;

  print('$nama, $umur th, $kota $tahun, $suhu C, aktif: $aktif');
}
```

### Output

```text:output.txt
Ani, 25 th, Jakarta 2026, 28.5 C, aktif: true
```

### Type Inference

Dart menggunakan **static type inference** — tipe ditentukan saat kompilasi, bukan runtime. Compiler menganalisis kode untuk menentukan tipe paling spesifik.

```dart:inference.dart
void main() {
  var x = 10;       // int
  var y = 3.14;     // double
  var z = x + y;    // double (numeric widening)

  var list = [1, 2, 3];          // List<int>
  var map = {'a': 1, 'b': 2};    // Map<String, int>

  print('x: ${x.runtimeType}');  // int
  print('y: ${y.runtimeType}');  // double
  print('z: ${z.runtimeType}');  // double
  print('list: ${list.runtimeType}');  // List<int>
}
```

### Output

```text:output.txt
x: int
y: double
z: double
list: List<int>
```

### Tipe Data Primitif

Dart tidak membedakan "primitive" dan "object" — semua tipe adalah object.

| Tipe Dart | Deskripsi | Contoh |
|-----------|-----------|--------|
| `int` | Bilangan bulat (arbitrary precision) | `42`, `-10` |
| `double` | Bilangan desimal (IEEE 754) | `3.14`, `1.5e10` |
| `num` | Superclass `int` dan `double` | `42` atau `3.14` |
| `String` | Urutan karakter UTF-16 | `'Halo'`, `"Dunia"` |
| `bool` | `true` atau `false` | `true` |
| `Null` | Hanya `null` | `null` |
| `Object` | Superclass semua tipe (kecuali Null) | Semua nilai |
| `dynamic` | Mematikan type checking | Bisa apa saja |

### Null Safety

Dart 3 menerapkan **sound null safety**: variabel non-nullable tidak boleh `null`.

```dart:null_safety_intro.dart
void main() {
  String nonNull = 'Aman';       // Non-nullable
  String? nullable;              // Nullable — default null

  // nonNull = null;             // Error: String bukan String?
  nullable = null;               // OK
  nullable = 'Ada isinya';       // OK

  // Null-aware operators
  print(nullable?.length);       // 10 (akses aman)
  print(nullable ?? 'Default');  // Ada isinya (if-null)
}
```

### Output

```text:output.txt
10
Ada isinya
```

### Navigasi Sub-bab

- [Numbers](/03-fundamentals/variabel/numbers) — `int`, `double`, `num`, operator aritmatika
- [Strings](/03-fundamentals/variabel/strings) — Literal, interpolasi, escape
- [Booleans](/03-fundamentals/variabel/booleans) — `bool`, operator logika, truthiness
- [Collections](/03-fundamentals/variabel/collections) — `List`, `Set`, `Map`, spread, collection-if/for