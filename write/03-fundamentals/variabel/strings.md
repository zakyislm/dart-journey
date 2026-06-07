---
title: Strings
subtitle: Manipulasi teks di Dart: literal, interpolasi, escape sequences, dan operasi string
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Variabel & Tipe Data
  - Strings
pagination:
  prev_title: Numbers
  prev_url: /03-fundamentals/variabel/numbers
  next_title: Booleans
  next_url: /03-fundamentals/variabel/booleans
---

`String` di Dart merepresentasikan urutan karakter UTF-16. Dart menyediakan konstruksi literal yang kaya, interpolasi ekspresi, dan banyak method untuk manipulasi teks. Semua string adalah immutable.

### Literal String

```dart:string_literals.dart
void main() {
  // Single quotes atau double quotes — sama saja
  String s1 = 'Halo Dunia';
  String s2 = "Halo Dunia";

  // Multi-line string dengan triple quotes
  String puisi = '''
  Baris pertama
  Baris kedua
    Baris ketiga (dengan indentasi)
  ''';

  // Raw string — escape sequence diabaikan
  String path = r'C:\Users\user\Documents\file.txt';
  // Tanpa r, \U dan \D akan dianggap escape sequence

  print(s1);
  print(s1 == s2);  // true
  print(puisi);
  print(path);       // C:\Users\user\Documents\file.txt
}
```

### Output

```text:output.txt
Halo Dunia
true

  Baris pertama
  Baris kedua
    Baris ketiga (dengan indentasi)

C:\Users\user\Documents\file.txt
```

### Interpolasi String

```dart:string_interpolation.dart
void main() {
  var nama = 'Budi';
  var umur = 25;

  // \$variable — interpolasi variabel sederhana
  print('Nama: $nama, Umur: $umur');

  // \${expression} — untuk ekspresi kompleks
  print('Nama: ${nama.toUpperCase()}');
  print('Tahun depan: ${umur + 1}');
  print('Jumlah huruf: ${nama.length}');

  // Multi-expression
  var pesan = 'Halo, nama saya $nama. '
      'Saya berumur $umur tahun. '
      'Tahun depan saya ${umur + 1} tahun.';
  print(pesan);
}
```

### Output

```text:output.txt
Nama: Budi, Umur: 25
Nama: BUDI
Tahun depan: 26
Jumlah huruf: 4
Halo, nama saya Budi. Saya berumur 25 tahun. Tahun depan saya 26 tahun.
```

### Concatenation dan Adjacent Strings

```dart:string_concat.dart
void main() {
  // Operator + untuk concatenation
  String a = 'Halo' + ' ' + 'Dunia';
  print(a);  // Halo Dunia

  // Adjacent string literals otomatis digabung (tanpa +)
  String b = 'Ini adalah '
      'kalimat yang '
      'sangat panjang';
  print(b);  // Ini adalah kalimat yang sangat panjang

  // Concatenation dengan tipe lain
  String c = 'Nilai: ' + 42.toString();
  // String c = 'Nilai: ' + 42;  // Error: String + int tidak valid
  print(c);  // Nilai: 42
}
```

### Output

```text:output.txt
Halo Dunia
Ini adalah kalimat yang sangat panjang
Nilai: 42
```

### Method dan Properti String

```dart:string_methods.dart
void main() {
  String teks = '  Belajar Dart Itu Menyenangkan  ';

  // Properti
  print('Panjang: ${teks.length}');           // 34
  print('Kosong: ${teks.isEmpty}');           // false
  print('Tidak kosong: ${teks.isNotEmpty}');  // true

  // Case transformation
  print('Uppercase: ${teks.toUpperCase()}');   // BELAJAR DART ITU MENYENANGKAN
  print('Lowercase: ${teks.toLowerCase()}');   // belajar dart itu menyenangkan

  // Trim — menghilangkan whitespace di awal/akhir
  print('Trim: [$teks] -> [${teks.trim()}]');

  // Substring — mengambil sebagian string
  print('Substring(2, 9): ${teks.substring(2, 9)}');  // Belajar

  // Replace — mengganti substring
  print('Replace: ${teks.replaceAll('a', '4')}');
  print('ReplaceFirst: ${teks.replaceFirst('a', '4', 0)}');

  // Split — memecah string menjadi List
  var kataKata = teks.trim().split(' ');
  print('Split: $kataKata');
  print('Join: ${kataKata.join(' - ')}');

  // Contains — cek substring
  print('Contains "Dart": ${teks.contains('Dart')}');  // true
  print('Contains "Java": ${teks.contains('Java')}');  // false

  // StartsWith / EndsWith
  print('Starts with "  Belajar": ${teks.startsWith('  Belajar')}');  // true
  print('Ends with "kan  ": ${teks.endsWith('kan  ')}');              // true

  // IndexOf — mencari posisi
  print('Index of "Dart": ${teks.indexOf('Dart')}');  // 10
}
```

### Output

```text:output.txt
Panjang: 34
Kosong: false
Tidak kosong: true
Uppercase:   BELAJAR DART ITU MENYENANGKAN
Lowercase:   belajar dart itu menyenangkan
Trim: [  Belajar Dart Itu Menyenangkan  ] -> [Belajar Dart Itu Menyenangkan]
Substring(2, 9): Belajar
Replace:   Bel4j4r D4rt Itu Menyen4ngk4n
ReplaceFirst:   Bel4jar Dart Itu Menyenangkan
Split: [Belajar, Dart, Itu, Menyenangkan]
Join: Belajar - Dart - Itu - Menyenangkan
Contains "Dart": true
Contains "Java": false
Starts with "  Belajar": true
Ends with "kan  ": true
Index of "Dart": 10
```

### StringBuffer — Efisiensi Concatenation

Untuk operasi concatenation yang banyak di dalam loop, gunakan `StringBuffer`:

```dart:string_buffer.dart
void main() {
  // Tanpa StringBuffer — setiap + membuat string baru
  String result = '';
  for (int i = 0; i < 5; i++) {
    result += '$i ';  // Buat string baru setiap iterasi
  }
  print('Tanpa buffer: $result');

  // Dengan StringBuffer — efisien
  var buffer = StringBuffer();
  for (int i = 0; i < 5; i++) {
    buffer.write('$i ');
  }
  String resultBuffer = buffer.toString();
  print('Dengan buffer: $resultBuffer');

  // StringBuffer dengan writeAll
  var list = ['Dart', 'Flutter', 'OOP'];
  var buffer2 = StringBuffer();
  buffer2.writeAll(list, ', ');  // Gabung dengan separator
  print(buffer2.toString());      // Dart, Flutter, OOP
}
```

### Output

```text:output.txt
Tanpa buffer: 0 1 2 3 4
Dengan buffer: 0 1 2 3 4
Dart, Flutter, OOP
```

### Escape Sequences

| Sequence | Karakter |
|----------|----------|
| `\n` | Newline |
| `\t` | Tab |
| `\'` | Single quote |
| `\"` | Double quote |
| `\\` | Backslash |
| `\u{xxxx}` | Unicode code point |

```dart:escape_sequences.dart
void main() {
  print('Baris 1\nBaris 2');
  print('Kolom 1\tKolom 2');
  print('Dia berkata: \"Halo!\"');
  print('Emoji: \u{1F600}');  // 😀
}
```

### Output

```text:output.txt
Baris 1
Baris 2
Kolom 1        Kolom 2
Dia berkata: "Halo!"
Emoji: 😀