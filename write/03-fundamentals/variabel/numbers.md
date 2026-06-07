---
title: Numbers — int, double, num
subtitle: Tipe data numerik di Dart: integer presisi arbitrer, floating-point IEEE 754, dan operator aritmatika
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Variabel & Tipe Data
  - Numbers
pagination:
  prev_title: Variabel & Tipe Data
  prev_url: /03-fundamentals/variabel/index
  next_title: Strings
  next_url: /03-fundamentals/variabel/strings
---

Dart menyediakan dua tipe numerik konkret — `int` (bilangan bulat) dan `double` (bilangan desimal) — keduanya merupakan subtype dari `num`. Tidak seperti JavaScript yang hanya memiliki `Number`, Dart membedakan integer dan floating-point secara eksplisit.

### Overview Tipe Numerik

| Tipe | Deskripsi | Contoh |
|------|-----------|--------|
| `int` | Bilangan bulat (64-bit di native, arbitrary di web) | `0`, `42`, `-1`, `0xFF` |
| `double` | Floating-point IEEE 754 (64-bit) | `3.14`, `1.5e10`, `-0.5` |
| `num` | Superclass int dan double | Menerima keduanya |

### Deklarasi dan Literal

```dart:numeric_declaration.dart
void main() {
  // Integer — berbagai representasi
  int desimal = 42;           // Desimal (basis 10)
  int hex = 0xFF;             // Heksadesimal (basis 16) → 255
  int biner = 0b1010;         // Biner (basis 2) → 10

  // Double — desimal atau notasi ilmiah
  double pi = 3.14159;
  double avogadro = 6.022e23; // Notasi ilmiah
  double negatif = -273.15;

  // num — menerima int atau double
  num harga = 19;             // int literal
  harga = 19.99;              // kemudian diubah ke double

  // Type inference
  var a = 10;                 // → int
  var b = 10.0;               // → double (koma desimal)
  var c = 10 + 5.0;           // → double (numeric widening)

  print('desimal: $desimal, hex: $hex, biner: $biner');
  print('pi: $pi, avogadro: $avogadro, negatif: $negatif');
  print('a: ${a.runtimeType}, b: ${b.runtimeType}, c: ${c.runtimeType}');
}
```

### Output

```text:output.txt
desimal: 42, hex: 255, biner: 10
pi: 3.14159, avogadro: 6.022e+23, negatif: -273.15
a: int, b: double, c: double
```

### Operator Aritmatika

```dart:arithmetic_operators.dart
void main() {
  int x = 10;
  int y = 3;

  // Operator dasar
  print('x + y = ${x + y}');   // 13 — penjumlahan
  print('x - y = ${x - y}');   // 7 — pengurangan
  print('x * y = ${x * y}');   // 30 — perkalian
  print('x / y = ${x / y}');   // 3.333... — pembagian (selalu double)
  print('x ~/ y = ${x ~/ y}'); // 3 — pembagian integer (floor)
  print('x % y = ${x % y}');   // 1 — modulus (sisa bagi)
  print('-x = ${-x}');         // -10 — unary minus

  // Assignment operators
  var z = 10;
  z += 5;    // z = z + 5 → 15
  z -= 3;    // z = z - 3 → 12
  z *= 2;    // z = z * 2 → 24
  z ~/= 5;   // z = z ~/ 5 → 4
  print('z: $z');  // 4

  // Increment / Decrement
  var i = 0;
  print(i++);  // 0 (post-increment: return dulu, baru +1)
  print(++i);  // 2 (pre-increment: +1 dulu, baru return)
  print(i--);  // 2 (post-decrement)
  print(--i);  // 0 (pre-decrement)
}
```

### Output

```text:output.txt
x + y = 13
x - y = 7
x * y = 30
x / y = 3.3333333333333335
x ~/ y = 3
x % y = 1
-x = -10
z: 4
0
2
2
0
```

### Properti dan Method Numerik

Semua tipe numerik memiliki method dari class `num`, `int`, dan `double`:

```dart:numeric_methods.dart
void main() {
  int angka = -42;
  double pecahan = 3.14159;

  // Properti
  print(angka.isNegative);        // true
  print(angka.isEven);            // true
  print(angka.isOdd);             // false
  print(angka.abs());             // 42 — nilai absolut
  print(angka.sign);              // -1 (negatif), 0, atau 1

  // Konversi
  print(angka.toString());        // "-42" — ke String
  print(angka.toDouble());        // -42.0 — ke double
  print(pecahan.toInt());         // 3 — truncate (bukan round)
  print(pecahan.round());         // 3 — round ke terdekat
  print(pecahan.ceil());          // 4 — round up
  print(pecahan.floor());         // 3 — round down
  print(pecahan.toStringAsFixed(2)); // "3.14" — 2 desimal

  // Parsing
  print(int.parse('42'));         // 42 — dari String
  print(double.parse('3.14'));    // 3.14 — dari String
  // print(int.parse('abc'));     // Error: FormatException
  print(int.tryParse('abc'));     // null — aman jika gagal
}
```

### Output

```text:output.txt
true
true
false
42
-1
-42
-42.0
3
3
4
3
3.14
42
3.14
null
```

### Konstanta Numerik

```dart:numeric_constants.dart
void main() {
  const int maxInt = 9223372036854775807; // 2^63 - 1
  const double infinity = double.infinity;
  const double nan = double.nan;          // Not a Number
  const double negInfinity = double.negativeInfinity;

  print('Max int: $maxInt');
  print('Infinity: $infinity');
  print('NaN == NaN: ${nan == nan}');     // false (NaN ≠ NaN)
  print('NaN is NaN: ${nan.isNaN}');      // true (use .isNaN)
  print('1 / 0 = ${1 / 0}');             // Infinity (no exception)
  print('-1 / 0 = ${-1 / 0}');           // -Infinity
}
```

### Output

```text:output.txt
Max int: 9223372036854775807
Infinity: Infinity
NaN == NaN: false
NaN is NaN: true
1 / 0 = Infinity
-1 / 0 = -Infinity
```

> **Catatan**: Di platform native, `int` adalah 64-bit signed integer. Di web (JavaScript), Dart `int` dikompilasi ke JavaScript `Number` yang presisinya terbatas di ±2^53.