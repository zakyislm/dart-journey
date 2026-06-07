---
title: Null Safety in Dart
subtitle: Sound null safety, nullable types, null-aware operators, late variables, dan best practices
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - OOP & Lanjutan
  - Null Safety
pagination:
  prev_title: OOP Dasar
  prev_url: /04-oop-and-advanced/oop-dasar
  next_title: Asynchronous
  next_url: /04-oop-and-advanced/asynchronous
---

Null safety adalah fitur yang mencegah **null reference error** (billion-dollar mistake) di compile time. Dart menerapkan **sound null safety** — artinya compiler menjamin tipe non-nullable tidak akan pernah mengandung null.

### Prinsip Dasar

```dart:nullable_vs_nonnullable.dart
void main() {
  // Non-nullable — tidak boleh null (default)
  String name = 'Budi';
  int age = 25;
  // name = null;   // ERROR: Null tidak bisa diassign ke String

  // Nullable — boleh null (tanda ?)
  String? nickname;          // Default null
  int? optionalAge = null;

  print('Name: $name, Nickname: $nickname');
}
```

### Output

```text:output.txt
Name: Budi, Nickname: null
```

---

### Null-Aware Operators

| Operator | Nama | Fungsi |
|----------|------|--------|
| `?` | Nullable type | `int?` — boleh null |
| `??` | If-null | `a ?? b` — return b jika a null |
| `?.` | Null-aware access | `obj?.prop` — akses jika obj tidak null |
| `!` | Null assertion | `value!` — paksa compiler anggap tidak null |
| `??=` | Null-aware assignment | `a ??= b` — assign b jika a null |
| `...?` | Null-aware spread | `[...?list]` — spread jika list tidak null |

```dart:null_operators.dart
void main() {
  // ?? operator — if-null
  String? input;
  String result = input ?? 'Default';
  print(result);                              // Default

  // ?. operator — safe access
  String? text;
  print(text?.length);                        // null
  print(text?.toUpperCase());                 // null

  String text2 = 'Hello';
  print(text2?.length);                       // 5

  // ??= operator — assign if null
  int? score;
  score ??= 100;
  print(score);                               // 100
  score ??= 50;
  print(score);                               // 100 (tidak berubah)

  // ...? spread operator
  List<int>? maybeList;
  var combined = [1, 2, ...?maybeList, 3];
  print(combined);                            // [1, 2, 3]

  // ! operator — null assertion (hati-hati!)
  String? data = 'Ada';
  String forced = data!;                      // Paksa non-null
  print(forced.length);                       // 3

  // data = null;
  // String error = data!;                    // RUNTIME ERROR: Null check failed
}
```

### Output

```text:output.txt
Default
null
null
5
100
100
[1, 2, 3]
3
```

---

### Type Promotion (Flow Analysis)

Dart compiler pintar — jika setelah null-check, compiler otomatis memperlakukan variabel nullable sebagai non-nullable.

```dart:type_promotion.dart
void printLength(String? text) {
  // text.length;  // ERROR: text bisa null

  if (text != null) {
    // Type promotion — text dianggap String di sini
    print('Panjang: ${text.length}');    // OK
  }

  // Cara lain
  if (text == null) return;              // Early return
  print('Panjang: ${text.length}');      // OK — sudah pasti tidak null
}

void main() {
  printLength('Halo');   // Panjang: 4
  printLength(null);     // (tidak print apa-apa)
}
```

### Output

```text:output.txt
Panjang: 4
```

---

### Late Variables

`late` untuk variabel yang akan diinisialisasi nanti, tapi dijamin tidak null saat diakses.

```dart:late_variables.dart
class Database {
  late String connection;  // Akan diinisialisasi sebelum digunakan

  void connect() {
    connection = 'Connected to DB';
    print(connection);
  }

  // Late final — diinisialisasi sekali, malas (lazy)
  static late final DateTime startTime = DateTime.now();
}

void main() {
  var db = Database();

  // print(db.connection);  // ERROR: LateInitializationError (belum inisialisasi)
  db.connect();             // Connected to DB
  print(db.connection);     // OK

  // Late final lazy
  print(Database.startTime);  // DateTime saat pertama diakses
}
```

### Output

```text:output.txt
Connected to DB
Connected to DB
2026-06-07 10:30:00.000
```

---

### Null Safety di Collections

```dart:null_collections.dart
void main() {
  // List nullable vs non-nullable
  List<String?> mixed = ['A', null, 'C'];
  List<String> strict = ['A', 'B', 'C'];

  // Akses element nullable list
  for (var item in mixed) {
    print(item?.length ?? 0);  // Safe access
  }

  // Map nullable value
  Map<String, int?> scores = {'A': 100, 'B': null};
  for (var entry in scores.entries) {
    print('${entry.key}: ${entry.value ?? "N/A"}');
  }
}
```

### Output

```text:output.txt
1
0
1
A: 100
B: N/A
```

---

### Null Safety di Function

```dart:null_functions.dart
// Parameter nullable
String greet(String? name) {
  return 'Halo, ${name ?? "Dunia"}!';
}

// Return type nullable
int? tryParse(String input) {
  return int.tryParse(input);  // Bisa return null
}

// Required parameter (tidak boleh null)
void requiredParam({required String name}) {
  print('Nama: $name');
}

// Optional nullable parameter
void optionalParam([String? title]) {
  print('Title: ${title ?? "Tanpa Judul"}');
}

void main() {
  print(greet('Budi'));    // Halo, Budi!
  print(greet(null));      // Halo, Dunia!

  print(tryParse('42'));   // 42
  print(tryParse('abc'));  // null

  requiredParam(name: 'Ani');
  // requiredParam();       // ERROR: name required

  optionalParam('Bab 1');
  optionalParam();           // OK
}
```

### Output

```text:output.txt
Halo, Budi!
Halo, Dunia!
42
null
Nama: Ani
Title: Bab 1
Title: Tanpa Judul
```

---

### Migration Example: Tanpa Null Safety → Null Safety

```dart:migration.dart
// ===== SEBELUM NULL SAFETY =====
// class User {
//   String name;
//   User(this.name);
//   User.anonymous();    // name = null — bisa terjadi!
//   void printName() {
//     print(name.length);  // Bisa error runtime!
//   }
// }

// ===== SETELAH NULL SAFETY =====
class User {
  String name;

  User(this.name);

  // Jika memang perlu default tanpa name
  User.anonymous() : name = 'Anonymous';

  void printName() {
    print(name.length);  // Aman — name pasti non-null
  }
}

// Atau jika name memang opsional:
class OptionalUser {
  String? name;

  OptionalUser({this.name});

  void printName() {
    if (name != null) {
      print(name!.length);
    } else {
      print('Tidak ada nama');
    }
  }
}
```

---

### Best Practices

1. **Default non-nullable** — gunakan `?` hanya jika null memang valid
2. **Hindari `!` (null assertion)** — gunakan type promotion atau `??` sebagai gantinya
3. **Gunakan `late` hanya untuk dependency injection atau lazy initialization**
4. **Gunakan `required` untuk parameter wajib di named constructors**
5. **Manfaatkan flow analysis** compiler — tulis kode yang mudah dipromosikan

```dart:best_practice.dart
// BURUK — banyak ! assertion
String? data;
// ... somewhere ...
// print(data!.length);  // Berbahaya!

// BAIK — type promotion
if (data != null) {
  print(data.length);    // Aman
}

// LEBIH BAIK — null-aware operator
print(data?.length ?? 0);  // Aman dan ringkas