---
title: Collections — List, Set, Map
subtitle: Struktur data koleksi di Dart: List, Set, Map, spread operator, collection-if/for, dan method collection
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - Fundamental
  - Variabel & Tipe Data
  - Collections
pagination:
  prev_title: Booleans
  prev_url: /03-fundamentals/variabel/booleans
  next_title: Kontrol Alur
  next_url: /03-fundamentals/kontrol-alur/index
---

Dart menyediakan tiga koleksi utama bawaan: **List** (array berurutan), **Set** (kumpulan unik), dan **Map** (key-value pairs). Ketiganya adalah generic — dapat menyimpan tipe data apa pun. Dart 2.3+ menambahkan **collection-if**, **collection-for**, dan **spread operator** untuk literal yang ekspresif.

### List

List adalah koleksi berurutan (ordered) dengan index berbasis nol. Mirip array di bahasa lain.

```dart:list_basics.dart
void main() {
  // List literal — type inferred
  var numbers = [1, 2, 3, 4, 5];        // List<int>
  var names = ['Budi', 'Ani', 'Citra'];  // List<String>

  // List kosong
  var empty = <int>[];    // Tipe eksplisit
  var empty2 = [];        // List<dynamic> — tidak direkomendasikan

  // Akses elemen dengan index
  print('First: ${names.first}');     // Budi
  print('Last: ${names.last}');       // Citra
  print('Index 1: ${names[1]}');      // Ani
  print('Length: ${names.length}');   // 3

  // Modifikasi
  names[1] = 'Anisa';                 // Ubah elemen
  names.add('Doni');                  // Tambah di akhir
  names.insert(0, 'Awal');            // Sisip di index
  names.remove('Citra');              // Hapus berdasarkan nilai
  names.removeAt(2);                  // Hapus berdasarkan index

  print('After modification: $names');
}
```

### Output

```text:output.txt
First: Budi
Last: Citra
Index 1: Ani
Length: 3
After modification: [Awal, Budi, Doni]
```

### Method List Penting

```dart:list_methods.dart
void main() {
  var nums = [5, 2, 8, 1, 9, 2];

  // Sorting
  nums.sort();                          // [1, 2, 2, 5, 8, 9] — in-place
  print('Sorted: $nums');

  // Reversed
  var reversed = nums.reversed;         // Iterable (9, 8, 5, 2, 2, 1)
  print('Reversed: ${reversed.toList()}');

  // Higher-order functions
  var doubled = nums.map((n) => n * 2);
  print('Doubled: ${doubled.toList()}'); // [2, 4, 4, 10, 16, 18]

  var even = nums.where((n) => n.isEven);
  print('Even: ${even.toList()}');       // [2, 2, 8]

  var sum = nums.reduce((a, b) => a + b);
  print('Sum: $sum');                    // 27

  var hasNine = nums.any((n) => n == 9);
  print('Has 9: $hasNine');              // true

  var allPositive = nums.every((n) => n > 0);
  print('All positive: $allPositive');   // true

  // SubList — potongan list
  var subList = nums.sublist(1, 4);      // [2, 2, 5]
  print('SubList(1, 4): $subList');

  // Join
  print(nums.join(' - '));              // "1 - 2 - 2 - 5 - 8 - 9"
}
```

### Output

```text:output.txt
Sorted: [1, 2, 2, 5, 8, 9]
Reversed: [9, 8, 5, 2, 2, 1]
Doubled: [2, 4, 4, 10, 16, 18]
Even: [2, 2, 8]
Sum: 27
Has 9: true
All positive: true
SubList(1, 4): [2, 2, 5]
1 - 2 - 2 - 5 - 8 - 9
```

### List Growth Modes (Fixed vs Growable)

```dart:list_growth.dart
void main() {
  // Growable list (default) — bisa bertambah panjang
  var growable = <int>[];
  growable.add(1);
  growable.add(2);
  print('Growable: $growable (length: ${growable.length})');

  // Fixed-length list via List.filled
  var fixed = List<int>.filled(5, 0);   // 5 elemen, semua 0
  fixed[2] = 42;                         // Ubah elemen
  // fixed.add(3);                       // ERROR: Cannot add to fixed list
  print('Fixed: $fixed (length: ${fixed.length})');

  // Generate list
  var generated = List<int>.generate(5, (i) => i * i);  // [0, 1, 4, 9, 16]
  print('Generated: $generated');
}
```

### Output

```text:output.txt
Growable: [1, 2] (length: 2)
Fixed: [0, 0, 42, 0, 0] (length: 5)
Generated: [0, 1, 4, 9, 16]
```

### Set

Set adalah koleksi tidak berurutan dengan elemen unik (tidak ada duplikat).

```dart:set_basics.dart
void main() {
  // Set literal
  var fruits = {'apple', 'banana', 'orange'};  // Set<String>
  print('Fruits: $fruits');

  // Set dari List — otomatis deduplicate
  var nums = [1, 2, 2, 3, 3, 3, 4];
  var uniqueNums = nums.toSet();               // {1, 2, 3, 4}
  print('Unique: ${uniqueNums.toList()}');

  // Set kosong
  var empty = <String>{};

  // Operasi set
  fruits.add('mango');              // Tambah
  fruits.add('apple');              // Duplikat — diabaikan
  fruits.remove('banana');          // Hapus
  print('Contains apple: ${fruits.contains('apple')}');  // true

  // Set operations (union, intersection, difference)
  var setA = {1, 2, 3, 4};
  var setB = {3, 4, 5, 6};

  print('Union: ${setA.union(setB)}');           // {1, 2, 3, 4, 5, 6}
  print('Intersection: ${setA.intersection(setB)}'); // {3, 4}
  print('Difference: ${setA.difference(setB)}');  // {1, 2}
}
```

### Output

```text:output.txt
Fruits: {apple, banana, orange}
Unique: [1, 2, 3, 4]
Contains apple: true
Union: {1, 2, 3, 4, 5, 6}
Intersection: {3, 4}
Difference: {1, 2}
```

### Map

Map menyimpan data sebagai key-value pairs. Key harus unik.

```dart:map_basics.dart
void main() {
  // Map literal
  var scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92,
  };  // Map<String, int>

  // Map kosong
  var empty = <String, int>{};

  // Akses
  print("Alice's score: ${scores['Alice']}");  // 95
  print("Unknown: ${scores['Unknown']}");       // null (key tidak ada)

  // Modifikasi
  scores['Alice'] = 97;             // Update
  scores['Diana'] = 88;             // Insert
  scores.remove('Bob');             // Delete

  // Properti
  print('Keys: ${scores.keys}');     // (Alice, Charlie, Diana)
  print('Values: ${scores.values}'); // (97, 92, 88)
  print('Length: ${scores.length}'); // 3

  // Cek keberadaan key
  print('Has Alice: ${scores.containsKey('Alice')}');   // true
  print('Has value 100: ${scores.containsValue(100)}');  // false
}
```

### Output

```text:output.txt
Alice's score: 95
Unknown: null
Keys: (Alice, Charlie, Diana)
Values: (97, 92, 88)
Length: 3
Has Alice: true
Has value 100: false
```

### Advanced: Spread, Collection-if, Collection-for

```dart:collection_advanced.dart
void main() {
  // Spread operator (...) — menyebar elemen collection
  var list1 = [1, 2, 3];
  var list2 = [0, ...list1, 4, 5];
  print('Spread: $list2');  // [0, 1, 2, 3, 4, 5]

  // Null-aware spread (...?) — abaikan jika null
  List<int>? nullableList;
  var list3 = [0, ...?nullableList, 1];
  print('Null-aware spread: $list3');  // [0, 1]

  // Collection-if — kondisional dalam literal
  var includeExtra = true;
  var list4 = [1, 2, if (includeExtra) 3, 4];
  print('Collection-if (true): $list4');   // [1, 2, 3, 4]

  includeExtra = false;
  var list5 = [1, 2, if (includeExtra) 3, 4];
  print('Collection-if (false): $list5');  // [1, 2, 4]

  // Collection-for — loop dalam literal
  var list6 = [0, for (var i = 1; i <= 3; i++) i, 4];
  print('Collection-for: $list6');  // [0, 1, 2, 3, 4]

  // Collection-for dengan Set dan Map
  var set = {for (var i = 1; i <= 3; i++) 'item$i'};
  print('Set collection-for: $set');  // {item1, item2, item3}

  var map = {for (var i = 1; i <= 3; i++) 'key$i': i * 10};
  print('Map collection-for: $map');  // {key1: 10, key2: 20, key3: 30}
}
```

### Output

```text:output.txt
Spread: [0, 1, 2, 3, 4, 5]
Null-aware spread: [0, 1]
Collection-if (true): [1, 2, 3, 4]
Collection-if (false): [1, 2, 4]
Collection-for: [0, 1, 2, 3, 4]
Set collection-for: {item1, item2, item3}
Map collection-for: {key1: 10, key2: 20, key3: 30}
```

### Perbandingan Collection

| Aspek | List | Set | Map |
|-------|------|-----|-----|
| Urutan | Ya (index) | Tidak | Berdasarkan insertion |
| Duplikat | Boleh | Tidak | Key tidak, value boleh |
| Akses | `list[0]` | `set.contains()` | `map['key']` |
| Kekosongan | `[]` | `{}` | `{}` |
| Penggunaan | Urutan penting | Unik penting | Key-value |
| Turbo code | `for`, `if`, `...` | `for`, `if`, `...` | `for`, `if`, `...` |