---
title: Booleans
subtitle: Tipe bool, operator logika, perbandingan, dan pola evaluasi boolean di Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Variabel & Tipe Data
  - Booleans
pagination:
  prev_title: Strings
  prev_url: /03-fundamentals/variabel/strings
  next_title: Collections
  next_url: /03-fundamentals/variabel/collections
---

`bool` adalah tipe data paling sederhana di Dart — hanya memiliki dua nilai: `true` dan `false`. Tidak seperti JavaScript, Dart menerapkan **strict boolean checking**: hanya `true` yang dianggap true, hanya `false` yang dianggap false. Tidak ada konsep "truthy" atau "falsy".

### Deklarasi Boolean

```dart:bool_declaration.dart
void main() {
  bool aktif = true;
  bool selesai = false;

  // Boolean dari ekspresi
  bool lebihBesar = 10 > 5;           // true
  bool samaDengan = 'abc' == 'def';    // false
  bool tidakSama = 10 != 5;            // true

  print('aktif: $aktif');
  print('selesai: $selesai');
  print('10 > 5: $lebihBesar');
  print('"abc" == "def": $samaDengan');
  print('10 != 5: $tidakSama');

  // Nullable boolean
  bool? mungkinBool;    // null, true, atau false
  print('mungkinBool: $mungkinBool');  // null
}
```

### Output

```text:output.txt
aktif: true
selesai: false
10 > 5: true
"abc" == "def": false
10 != 5: true
mungkinBool: null
```

### Operator Perbandingan

```dart:comparison_operators.dart
void main() {
  int a = 10;
  int b = 5;
  int c = 10;

  print('a == b: ${a == b}');   // false — sama dengan
  print('a != b: ${a != b}');   // true — tidak sama
  print('a > b: ${a > b}');     // true — lebih besar
  print('a < b: ${a < b}');     // false — lebih kecil
  print('a >= c: ${a >= c}');   // true — lebih besar atau sama
  print('a <= c: ${a <= c}');   // true — lebih kecil atau sama

  // Perbandingan string (case-sensitive)
  print('"A" == "a": ${'A' == 'a'}');           // false
  print('"abc".compareTo("abd") < 0: ${'abc'.compareTo('abd') < 0}'); // true (lexicographic)

  // Perbandingan dengan is (type check)
  print('"Halo" is String: ${'Halo' is String}');  // true
  print('"Halo" is int: ${'Halo' is int}');         // false
}
```

### Output

```text:output.txt
a == b: false
a != b: true
a > b: true
a < b: false
a >= c: true
a <= c: true
"A" == "a": false
"abc".compareTo("abd") < 0: true
"Halo" is String: true
"Halo" is int: false
```

### Operator Logika

```dart:logical_operators.dart
void main() {
  bool x = true;
  bool y = false;

  // AND (&&) — true jika keduanya true
  print('x && y: ${x && y}');       // false
  print('x && true: ${x && true}'); // true

  // OR (||) — true jika salah satu true
  print('x || y: ${x || y}');       // true
  print('y || false: ${y || false}'); // false

  // NOT (!) — negasi
  print('!x: ${!x}');               // false
  print('!y: ${!y}');               // true

  // Kombinasi
  print('(x && y) || (!y): ${(x && y) || (!y)}'); // true
  // Evaluasi: (false) || (true) = true
}
```

### Output

```text:output.txt
x && y: false
x && true: true
x || y: true
y || false: false
!x: false
!y: true
(x && y) || (!y): true
```

### Short-circuit Evaluation

Operator `&&` dan `||` menerapkan **short-circuit evaluation**: operand kedua hanya dievaluasi jika hasil sudah tidak bisa ditentukan dari operand pertama.

```dart:short_circuit.dart
void main() {
  // AND short-circuit: jika kiri false, kanan tidak dievaluasi
  bool result1 = false && (throw 'Tidak akan dieksekusi');
  print('result1: $result1');  // false

  // OR short-circuit: jika kiri true, kanan tidak dievaluasi
  bool result2 = true || (throw 'Tidak akan dieksekusi');
  print('result2: $result2');  // true

  // Berguna untuk null-check
  String? nama;
  // print(nama.length);  // Error: nullable
  print(nama != null && nama.length > 0);  // false — aman
}
```

### Output

```text:output.txt
result1: false
result2: true
false
```

### Boolean Expression in Conditions

Dart TIDAK mengizinkan non-boolean dalam kondisi `if`, `while`, atau `assert`. Ini berbeda dengan JavaScript/C yang menerima truthy/falsy.

```dart:strict_bool.dart
void main() {
  // if (1) { }         // ERROR: int bukan bool
  // if ('Halo') { }    // ERROR: String bukan bool
  // if (null) { }      // ERROR: null bukan bool

  // Yang benar:
  if (1 > 0) { }             // OK: ekspresi menghasilkan bool
  if ('Halo'.isNotEmpty) { } // OK
  if (true) { }              // OK

  // Null check dengan nullable bool
  bool? flag = null;
  // if (flag) { }           // ERROR: bool? bukan bool
  if (flag == true) { }     // OK: perbandingan menghasilkan bool
  if (flag ?? false) { }    // OK: ?? menghasilkan bool non-null

  print('Strict boolean checking aktif!');
}
```

### Output

```text:output.txt
Strict boolean checking aktif!
```

### Method Boolean

```dart:bool_methods.dart
void main() {
  int angka = 7;

  // Properti built-in
  print(angka.isEven);     // false
  print(angka.isOdd);      // true
  print(angka.isNegative); // false
  print(angka.isFinite);   // true (untuk num)

  // String boolean checks
  String s = '';
  print(s.isEmpty);        // true
  print(s.isNotEmpty);     // false

  // Null-aware operators dengan bool
  bool? mungkin = null;
  print(mungkin ?? false); // false — fallback jika null
}
```

### Output

```text:output.txt
false
true
false
true
true
false
false