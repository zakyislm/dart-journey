---
title: If-Else
subtitle: Percabangan kondisional di Dart: if, else if, else, ternary operator, dan if-case pattern matching
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Kontrol Alur
  - If-Else
pagination:
  prev_title: Kontrol Alur
  prev_url: /03-fundamentals/kontrol-alur/index
  next_title: Switch-Case
  next_url: /03-fundamentals/kontrol-alur/switch-case
---

Struktur `if-else` adalah mekanisme percabangan paling dasar di Dart. Eksekusi blok kode ditentukan oleh hasil evaluasi ekspresi boolean. Dart 3 menambahkan **if-case** yang memungkinkan pattern matching dalam kondisi if.

### If Dasar

```dart:if_basic.dart
void main() {
  int nilai = 85;

  // If sederhana
  if (nilai >= 60) {
    print('Lulus');
  }

  // If dengan else
  if (nilai >= 90) {
    print('Grade: A');
  } else {
    print('Grade: Bukan A');
  }

  // If-else if-else berantai
  if (nilai >= 90) {
    print('Grade: A');
  } else if (nilai >= 80) {
    print('Grade: B');
  } else if (nilai >= 70) {
    print('Grade: C');
  } else if (nilai >= 60) {
    print('Grade: D');
  } else {
    print('Grade: E (Tidak Lulus)');
  }
}
```

### Output

```text:output.txt
Lulus
Grade: Bukan A
Grade: B
```

### If Tanpa Kurung Kurawal

Dart mengizinkan if tanpa kurung kurawal `{}` untuk satu statement — namun **tidak direkomendasikan** karena rawan bug.

```dart:if_no_braces.dart
void main() {
  var x = 5;

  // Bisa tanpa {} untuk satu statement
  if (x > 0) print('Positif');

  // Tapi hati-hati — ini cuma satu statement
  if (x > 0)
    print('Baris 1');  // Hanya ini yang masuk if
    print('Baris 2');  // INI DI LUAR IF — selalu dieksekusi

  // Rekomendasi: selalu gunakan {}
  if (x > 0) {
    print('Baris 1');
    print('Baris 2');
  }
}
```

### Output

```text:output.txt
Positif
Baris 1
Baris 2
Baris 1
Baris 2
```

### Ternary Operator ( ? : )

Ternary operator `condition ? expr1 : expr2` adalah shortcut untuk if-else sederhana dalam ekspresi.

```dart:ternary.dart
void main() {
  int umur = 20;

  // Ternary — if-else dalam satu ekspresi
  String status = umur >= 17 ? 'Dewasa' : 'Anak';
  print('Status: $status');  // Dewasa

  // Setara dengan:
  String statusIf;
  if (umur >= 17) {
    statusIf = 'Dewasa';
  } else {
    statusIf = 'Anak';
  }

  // Nested ternary (hati-hati — bisa sulit dibaca)
  int nilai = 75;
  String grade = nilai >= 90
      ? 'A'
      : nilai >= 80
          ? 'B'
          : nilai >= 70
              ? 'C'
              : 'D';
  print('Grade: $grade');  // C

  // Ternary dalam interpolasi string
  print('Anda ${umur >= 17 ? 'boleh' : 'belum boleh'} memilih.');
}
```

### Output

```text:output.txt
Status: Dewasa
Grade: C
Anda boleh memilih.
```

### Null-Aware dalam Kondisi

Dengan null safety, ekspresi kondisional harus menghasilkan `bool` non-nullable.

```dart:null_aware_if.dart
void main() {
  String? nama;
  String? alias = 'Budi';

  // Null check manual
  if (nama != null && nama.isNotEmpty) {
    print('Nama: $nama');
  } else {
    print('Nama kosong');
  }

  // Null-aware if — versi ringkas
  if (alias?.isNotEmpty ?? false) {
    print('Alias: $alias');
  }

  // Null-aware assignment dalam if
  String fallback;
  if (nama != null) {
    fallback = nama;
  } else if (alias != null) {
    fallback = alias;
  } else {
    fallback = 'Anonim';
  }
  print('Dipanggil: $fallback');

  // Setara dengan null-coalescing:
  String dipanggil = nama ?? alias ?? 'Anonim';
  print('Dipanggil: $dipanggil');
}
```

### Output

```text:output.txt
Nama kosong
Alias: Budi
Dipanggil: Budi
Dipanggil: Budi
```

### If-Case (Dart 3+) — Pattern Matching dalam If

Dart 3 memperkenalkan **if-case** untuk mencocokkan dan mendestruktur pattern dalam kondisi if.

```dart:if_case.dart
void main() {
  // 1. If-case dengan tipe
  Object maybeInt = 42;
  if (maybeInt case int value) {
    print('Integer: $value');          // Integer: 42
  }

  // 2. If-case dengan destructuring
  var point = (10, 20);               // Record (Dart 3)
  if (point case (int x, int y)) {
    print('Koordinat: ($x, $y)');     // Koordinat: (10, 20)
  }

  // 3. If-case dengan guard clause (when)
  Object maybeString = 'Hello';
  if (maybeString case String s when s.length > 3) {
    print('String panjang: $s');      // String panjang: Hello
  } else {
    print('Tidak cocok');
  }

  // 4. If-case dalam loop
  var items = [1, 'dua', 3, 'empat', 5];
  for (var item in items) {
    if (item case int i) {
      print('Integer: $i');
    }
  }
}
```

### Output

```text:output.txt
Integer: 42
Koordinat: (10, 20)
String panjang: Hello
Integer: 1
Integer: 3
Integer: 5
```

### Tips & Best Practices

1. **Selalu gunakan `{}`** — bahkan untuk satu statement, untuk menghindari bug
2. **Ternary untuk assignment** — gunakan ternary hanya untuk memilih nilai, bukan side effect
3. **Jangan nested ternary** — maksimal 2 level, lebih baik gunakan if-else berantai
4. **Gunakan early return** — keluar dari fungsi secepat mungkin untuk mengurangi nesting
5. **If-case untuk type narrowing** — gunakan if-case untuk pattern matching yang clean

```dart:early_return.dart
// Early return — kurangi nesting
String checkValue(int x) {
  if (x < 0) return 'Negatif';
  if (x == 0) return 'Nol';
  if (x > 100) return 'Sangat besar';

  // Main logic di sini — tidak nested
  return 'Nilai: $x';
}