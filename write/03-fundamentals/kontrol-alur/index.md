---
title: Control Flow
subtitle: Struktur kontrol di Dart: percabangan (if-else, switch-case) dan perulangan (for, while, do-while)
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Kontrol Alur
pagination:
  prev_title: Collections
  prev_url: /03-fundamentals/variabel/collections
  next_title: If-Else
  next_url: /03-fundamentals/kontrol-alur/if-else
---

Kontrol alur menentukan bagaimana program mengeksekusi instruksi berdasarkan kondisi dan perulangan. Dart menyediakan struktur kontrol yang familier dari bahasa C-style, dengan beberapa peningkatan modern seperti **pattern matching di switch** (Dart 3) dan **collection-for** untuk literal.

### Overview Kontrol Alur di Dart

| Struktur | Fungsi | Dart 3+ Enhancement |
|----------|--------|---------------------|
| `if-else` | Percabangan kondisional | `if-case` pattern matching |
| `switch-case` | Percabangan multi-kondisi | Pattern matching, exhaustiveness check, guard clause |
| `for` | Perulangan dengan counter | `for-in` untuk Iterable |
| `while` | Perulangan dengan kondisi di awal | — |
| `do-while` | Perulangan dengan kondisi di akhir | — |

### Prinsip Dasar

**Strict boolean condition.** Dart hanya menerima ekspresi `bool` dalam kondisi `if`, `while`, dan `assert`. Tidak ada konversi otomatis dari tipe lain ke boolean.

```dart:strict_bool_condition.dart
void main() {
  var items = [1, 2, 3];

  // if (items) { }         // ERROR: List<int> bukan bool
  if (items.isNotEmpty) {   // OK: ekspresi menghasilkan bool
    print('Items: $items');
  }

  var name = '';
  // while (name) { }       // ERROR: String bukan bool
  while (name.isEmpty) {     // OK
    name = 'Halo';
  }
}
```

### Output

```text:output.txt
Items: [1, 2, 3]
```

### Scope (Block Scope)

Variabel yang dideklarasikan di dalam blok `{}` hanya hidup di dalam blok tersebut.

```dart:block_scope.dart
void main() {
  var x = 10;

  if (x > 5) {
    var y = x * 2;    // y hanya hidup di blok ini
    print('Di dalam if: y = $y');
  }
  // print(y);         // ERROR: y tidak dikenal di luar blok

  // Variabel luar bisa diakses di dalam
  print('Di luar: x = $x');  // OK
}
```

### Output

```text:output.txt
Di dalam if: y = 20
Di luar: x = 10
```

### Navigasi Sub-bab

- [If-Else](/03-fundamentals/kontrol-alur/if-else) — Percabangan dasar dan if-case pattern
- [Switch-Case](/03-fundamentals/kontrol-alur/switch-case) — Multi-cabang, pattern matching, exhaustiveness
- [Loops](/03-fundamentals/kontrol-alur/loops) — for, while, do-while, for-in, break, continue