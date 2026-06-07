---
title: OOP & Advanced Concepts
subtitle: Pemrograman Berorientasi Objek, Null Safety, dan Pemrograman Asynchronous di Dart
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - OOP & Lanjutan
pagination:
  prev_title: Loops
  prev_url: /03-fundamentals/kontrol-alur/loops
  next_title: OOP Dasar
  next_url: /04-oop-and-advanced/oop-dasar
---

Bab ini mencakup tiga pilar penting dalam pengembangan Dart modern: **Object-Oriented Programming (OOP)**, **Null Safety**, dan **Asynchronous Programming**. Ketiga konsep ini adalah fondasi untuk membangun aplikasi Flutter yang robust.

### Mengapa OOP di Dart?

Dart adalah bahasa **berorientasi objek murni** — semua tipe adalah object, termasuk `int`, `double`, `bool`, dan bahkan `null` (sebagai tipe `Null`). Setiap class implicit mewarisi dari `Object?` (Dart 3).

```dart:everything_is_object.dart
void main() {
  // Semua tipe adalah object
  print(42.runtimeType);           // int
  print('Halo'.runtimeType);       // String
  print(true.runtimeType);         // bool
  print([1, 2, 3].runtimeType);    // List<int>

  // Semua bisa memiliki method
  print(42.isEven);                // true
  print('Halo'.toUpperCase());     // HALO
}
```

### Output

```text:output.txt
int
String
bool
List<int>
true
HALO
```

### Konsep Kunci di Bab Ini

| Topik | Deskripsi | Status |
|-------|-----------|--------|
| **OOP Dasar** | Class, Object, Constructor, Inheritance, Abstract | ✔ Stable |
| **Encapsulation** | Public/private, getter/setter | ✔ Stable |
| **Inheritance** | extends, super, method override | ✔ Stable |
| **Mixins** | Code reuse tanpa inheritance | ✔ Stable |
| **Interfaces** | implicit interface, implements | ✔ Stable |
| **Null Safety** | Sound null safety, ?, !, ??, late | ✔ Dart 2.12+ |
| **Generics** | Type parameter `<T>` | ✔ Stable |
| **Async/Await** | Future, async, await | ✔ Stable |
| **Streams** | Stream, yield, async* | ✔ Stable |
| **Isolates** | Concurrency model | ✔ Stable |

### Arsitektur OOP Dart

```
          Object? (nullable root)
              |
           Object
          /      \
    Primitive    User Classes
    (int, String,  (Vehicle, Animal...)
     bool, List...)
```

### Navigasi Sub-bab

- [OOP Dasar](/04-oop-and-advanced/oop-dasar) — Class, Object, Constructor, Inheritance, Mixins, Encapsulation, Generics
- [Null Safety](/04-oop-and-advanced/null-safety) — Sound null safety, nullable types, null-aware operators, late variables
- [Asynchronous](/04-oop-and-advanced/asynchronous) — Future, async/await, Streams, Isolates