---
title: Loops
subtitle: Struktur perulangan di Dart: for, while, do-while, for-in, forEach, break, continue
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Kontrol Alur
  - Loops
pagination:
  prev_title: Switch-Case
  prev_url: /03-fundamentals/kontrol-alur/switch-case
  next_title: Fungsi Dasar
  next_url: /03-fundamentals/fungsi/index
---

Dart menyediakan beberapa struktur perulangan: **for** (klasik), **for-in** (iterasi koleksi), **while**, dan **do-while**. Semua mendukung `break` (hentikan paksa) dan `continue` (lewati iterasi). Dart tidak memiliki label loop khusus — gunakan label untuk nested loop.

### For Loop Klasik

```dart:for_loop.dart
void main() {
  // For klasik: (inisialisasi; kondisi; increment)
  for (int i = 0; i < 5; i++) {
    print('Iterasi $i');
  }

  // Beberapa variabel
  for (int i = 0, j = 10; i < j; i++, j--) {
    print('i=$i, j=$j');
  }

  // Loop tanpa body
  int sum = 0;
  for (int i = 1; i <= 10; sum += i, i++);
  print('Jumlah 1-10: $sum');  // 55
}
```

### Output

```text:output.txt
Iterasi 0
Iterasi 1
Iterasi 2
Iterasi 3
Iterasi 4
i=0, j=10
i=1, j=9
i=2, j=8
i=3, j=7
i=4, j=6
Jumlah 1-10: 55
```

### For-In Loop

```dart:for_in.dart
void main() {
  var names = ['Budi', 'Ani', 'Citra'];

  // For-in — iterasi elemen langsung
  for (var name in names) {
    print('Halo, $name!');
  }

  // For-in dengan Map
  var scores = {'Alice': 95, 'Bob': 87, 'Charlie': 92};
  for (var entry in scores.entries) {
    print('${entry.key}: ${entry.value}');
  }

  // Destructuring di for-in (Dart 3)
  for (var MapEntry(:key, :value) in scores.entries) {
    print('$key => $value');
  }
}
```

### Output

```text:output.txt
Halo, Budi!
Halo, Ani!
Halo, Citra!
Alice: 95
Bob: 87
Charlie: 92
Alice => 95
Bob => 87
Charlie => 92
```

### While & Do-While

```dart:while_loop.dart
void main() {
  // While — cek kondisi di awal
  int count = 0;
  while (count < 3) {
    print('While: $count');
    count++;
  }

  // Do-while — eksekusi dulu, cek di akhir
  int i = 0;
  do {
    print('Do-while: $i');
    i++;
  } while (i < 3);

  // Do-while minimal 1x eksekusi
  int j = 10;
  do {
    print('Minimal 1x: $j');
  } while (j < 5);  // false, tapi sudah 1x eksekusi
}
```

### Output

```text:output.txt
While: 0
While: 1
While: 2
Do-while: 0
Do-while: 1
Do-while: 2
Minimal 1x: 10
```

### Break & Continue

```dart:break_continue.dart
void main() {
  // Break — hentikan loop sepenuhnya
  for (int i = 0; i < 10; i++) {
    if (i == 5) break;
    print('Break demo: $i');
  }  // Output: 0, 1, 2, 3, 4

  // Continue — lewati iterasi saat ini
  for (int i = 0; i < 5; i++) {
    if (i == 2) continue;
    print('Continue demo: $i');
  }  // Output: 0, 1, 3, 4

  // Break di nested loop dengan label
  outerLoop:
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (i == 1 && j == 1) break outerLoop;  // Keluar dari outer
      print('i=$i, j=$j');
    }
  }
  print('Selesai — keluar dari outer loop');
}
```

### Output

```text:output.txt
Break demo: 0
Break demo: 1
Break demo: 2
Break demo: 3
Break demo: 4
Continue demo: 0
Continue demo: 1
Continue demo: 3
Continue demo: 4
i=0, j=0
i=0, j=1
i=0, j=2
i=1, j=0
Selesai — keluar dari outer loop
```

### forEach & Higher-Order Iteration

```dart:foreach.dart
void main() {
  var numbers = [1, 2, 3, 4, 5];

  // forEach — callback per elemen (tidak bisa break/continue)
  numbers.forEach((n) {
    print('forEach: $n');
  });

  // Method rantaian
  numbers
      .where((n) => n.isEven)       // Filter: [2, 4]
      .map((n) => n * 10)           // Transform: [20, 40]
      .forEach((n) => print(n));    // Eksekusi

  // fold — accumulate
  var total = numbers.fold(0, (prev, n) => prev + n);
  print('Total: $total');  // 15
}
```

### Output

```text:output.txt
forEach: 1
forEach: 2
forEach: 3
forEach: 4
forEach: 5
20
40
Total: 15
```

### Perbandingan Struktur Loop

| Struktur | Kapan digunakan |
|----------|----------------|
| `for` | Jumlah iterasi diketahui, perlu index |
| `for-in` | Iterasi semua elemen collection |
| `while` | Kondisi berubah tidak terduga |
| `do-while` | Minimal 1x eksekusi |
| `forEach` | Transformasi/debug collection |
| `.map/.where` | Pipeline transformasi data |