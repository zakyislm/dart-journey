---
title: Dart Fundamentals
subtitle: Sintaks dasar, variabel, tipe data, kontrol alur, dan fungsi di Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
pagination:
  prev_title: IntelliJ IDEA
  prev_url: /02-preparation/ide/intellij-idea
  next_title: Variabel & Tipe Data
  next_url: /03-fundamentals/variabel/index
---

Bab fundamental mencakup semua konsep dasar yang diperlukan untuk mulai menulis program Dart: dari deklarasi variabel, tipe data primitif, struktur kontrol, hingga fungsi dan error handling. Setiap sub-bab dilengkapi kode contoh dan simulasi output.

### Struktur Program Dart

Setiap program Dart dimulai dari fungsi `main()`:

```dart:hello.dart
void main() {
  print('Halo, Dart!');
}
```

### Output

```text:output.txt
Halo, Dart!
```

### Konsep Kunci di Bab Ini

| Topik | Deskripsi | Status Dart 3 |
|-------|-----------|---------------|
| Variabel | var, final, const, type inference | ✔ Stable |
| Tipe Data | int, double, String, bool, List, Set, Map | ✔ Stable |
| Null Safety | Non-nullable by default, ?, ??, ! | ✔ Sound |
| Kontrol Alur | if-else, switch-case, for, while | ✔ + Pattern Matching (3.0) |
| Fungsi | Parameter, return, anonymous, arrow | ✔ Stable |
| Error Handling | try-catch, throw, Exception | ✔ Stable |

### Program Lengkap: Menghitung Rata-Rata

Sebagai gambaran konsep yang akan dipelajari:

```dart:rata_rata.dart
void main() {
  // Variabel dan tipe data
  List<int> nilai = [85, 90, 78, 92, 88];

  // Variabel final
  final int jumlahSiswa = nilai.length;

  // Perulangan dan akumulasi
  int total = 0;
  for (var n in nilai) {
    total += n;
  }

  // Operasi aritmatika
  double rataRata = total / jumlahSiswa;

  // Percabangan
  String status;
  if (rataRata >= 90) {
    status = 'Sangat Baik';
  } else if (rataRata >= 80) {
    status = 'Baik';
  } else {
    status = 'Cukup';
  }

  // Interpolasi string
  print('Total nilai: $total');
  print('Rata-rata: ${rataRata.toStringAsFixed(2)}');
  print('Status: $status');
}
```

### Output

```text:output.txt
Total nilai: 433
Rata-rata: 86.60
Status: Baik
```

### Navigasi Sub-bab

- [Variabel & Tipe Data](/03-fundamentals/variabel/index) — Deklarasi dan tipe data primitif
  - [Numbers](/03-fundamentals/variabel/numbers) — int, double, num
  - [Strings](/03-fundamentals/variabel/strings) — Manipulasi teks
  - [Booleans](/03-fundamentals/variabel/booleans) — bool dan operator logika
  - [Collections](/03-fundamentals/variabel/collections) — List, Set, Map
- [Kontrol Alur](/03-fundamentals/kontrol-alur/index) — Percabangan dan perulangan
  - [If-Else](/03-fundamentals/kontrol-alur/if-else) — Percabangan kondisional
  - [Switch-Case](/03-fundamentals/kontrol-alur/switch-case) — Pattern matching (Dart 3)
  - [Loops](/03-fundamentals/kontrol-alur/loops) — for, while, do-while