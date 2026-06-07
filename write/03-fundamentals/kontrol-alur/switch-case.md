---
title: Switch-Case
subtitle: Percabangan multi-kondisi dengan switch: classic syntax dan Dart 3 pattern matching
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Kontrol Alur
  - Switch-Case
pagination:
  prev_title: If-Else
  prev_url: /03-fundamentals/kontrol-alur/if-else
  next_title: Loops
  next_url: /03-fundamentals/kontrol-alur/loops
---

`switch-case` adalah alternatif `if-else` berantai untuk percabangan multi-kondisi. Dart 3 merevolusi switch dengan **pattern matching, exhaustiveness checking, dan guard clause**.

### Switch Klasik

```dart:switch_classic.dart
void main() {
  String command = 'OPEN';

  switch (command) {
    case 'OPEN':
      print('Membuka...');
      break;           // Wajib — mencegah fall-through
    case 'CLOSE':
      print('Menutup...');
      break;
    case 'SAVE':
      print('Menyimpan...');
      break;
    default:           // Opsional — jika tidak ada yang cocok
      print('Perintah tidak dikenal');
  }
}
```

### Output

```text:output.txt
Membuka...
```

### Switch Tanpa Break (Fall-Through)

Dart **tidak mengizinkan fall-through implisit**. Gunakan `continue` dengan label jika perlu.

```dart:switch_fallthrough.dart
void main() {
  int nilai = 2;

  switch (nilai) {
    case 1:
      print('Satu');
      continue labelDua;  // Lanjut ke case dua (explicit fall-through)
    labelDua:
    case 2:
      print('Dua');
      break;
    default:
      print('Lainnya');
  }
}
```

### Output

```text:output.txt
Dua
```

### Switch Expression (Dart 3+)

Dart 3 mengizinkan switch sebagai **expression** yang menghasilkan nilai. Ini memerlukan **exhaustiveness** — semua kasus harus ditangani.

```dart:switch_expression.dart
void main() {
  String status = 'loading';

  // Switch expression — menghasilkan nilai
  String message = switch (status) {
    'loading' => 'Memuat data...',
    'success' => 'Data berhasil dimuat!',
    'error'   => 'Terjadi kesalahan!',
    _         => 'Status tidak dikenal',  // Wildcard (default)
  };
  print(message);  // Memuat data...

  // Switch expression dengan tipe
  int code = 200;
  String desc = switch (code) {
    200 => 'OK',
    201 => 'Created',
    400 => 'Bad Request',
    404 => 'Not Found',
    500 => 'Internal Server Error',
    _   => 'Unknown Code',
  };
  print('$code: $desc');  // 200: OK

  // Tanpa wildcard _ — akan error jika tidak lengkap
  // String desc2 = switch (code) {
  //   200 => 'OK',
  //   404 => 'Not Found',
  //   // ERROR: Non-exhaustive switch expression
  // };
}
```

### Output

```text:output.txt
Memuat data...
200: OK
```

### Pattern Matching di Switch (Dart 3+)

Fitur paling powerful dari Dart 3 — switch dapat mendestruktur object, list, map, dan record.

```dart:switch_pattern.dart
void main() {
  // 1. Type pattern
  Object value = 42;

  String result = switch (value) {
    int i when i > 0  => 'Integer positif: $i',
    int i when i < 0  => 'Integer negatif: $i',
    int()             => 'Nol',
    String s when s.length > 5 => 'String panjang: ${s.length}',
    String()          => 'String pendek',
    List()            => 'List dengan ${(value as List).length} item',
    _                 => 'Tipe lain',
  };
  print(result);  // Integer positif: 42

  // 2. Destructuring List
  var list = [1, 2, 3];

  String listDesc = switch (list) {
    []                    => 'List kosong',
    [var first]           => 'List satu elemen: $first',
    [var first, var last] => 'Dua elemen: $first dan $last',
    [var x, var y, var z] => 'Tiga elemen: $x, $y, $z',
    _                     => 'List panjang',
  };
  print(listDesc);  // Tiga elemen: 1, 2, 3

  // 3. Destructuring Map
  var map = {'name': 'Budi', 'age': 25};

  String mapDesc = switch (map) {
    {'name': String name, 'age': int age} when age >= 18
        => '$name (dewasa, $age th)',
    {'name': String name, 'age': int age}
        => '$name (anak, $age th)',
    _   => 'Data tidak valid',
  };
  print(mapDesc);  // Budi (dewasa, 25 th)

  // 4. Destructuring Record (Dart 3)
  var point = (10, 20);

  String pointDesc = switch (point) {
    (0, 0)       => 'Origin',
    (var x, 0)   => 'Di sumbu X: $x',
    (0, var y)   => 'Di sumbu Y: $y',
    (var x, var y) when x == y => 'Diagonal: ($x, $y)',
    (var x, var y) => 'Koordinat: ($x, $y)',
  };
  print(pointDesc);  // Koordinat: (10, 20)
}
```

### Output

```text:output.txt
Integer positif: 42
Tiga elemen: 1, 2, 3
Budi (dewasa, 25 th)
Koordinat: (10, 20)
```

### Exhaustiveness Check

Switch expression **wajib mencakup semua kemungkinan**. Compiler akan memberikan error jika ada kasus yang terlewat.

```dart:exhaustiveness.dart
enum Status { loading, success, error }

String handleStatus(Status status) {
  // Ini exhaustive — semua enum value ditangani
  return switch (status) {
    Status.loading => 'Loading...',
    Status.success => 'Success!',
    Status.error   => 'Error!',
  };
  // Jika menambah enum value baru (misal: Status.timeout)
  // Compiler akan ERROR — harus ditangani
}

// Sealed class — ada di bab OOP
sealed class Result {}
class Success extends Result {}
class Error extends Result {}

String handleResult(Result result) {
  // Sealed class juga dicek exhaustiveness
  return switch (result) {
    Success() => 'Berhasil!',
    Error()   => 'Gagal!',
  };
}
```

### Perbandingan If-Else vs Switch

| Aspek | If-Else | Switch Klasik | Switch Expression (Dart 3) |
|-------|---------|---------------|---------------------------|
| Kondisi | Ekspresi boolean bebas | Nilai tunggal (==) | Pattern matching + when |
| Nilai balik | Manual (assign ke variabel) | Tidak langsung | Langsung (expression) |
| Exhaustiveness | Tidak dicek | Tidak dicek (default opsional) | Dicek compiler |
| Pattern matching | If-case (terbatas) | Tidak | Ya (penuh) |
| Lebih cocok untuk | Kondisi kompleks | Banyak == check | Pattern, enum, sealed class |