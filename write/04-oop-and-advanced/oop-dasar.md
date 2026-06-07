---
title: OOP Basics in Dart
subtitle: Class, Object, Constructor, Inheritance, Mixins, Encapsulation, dan Generics
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - OOP & Lanjutan
  - OOP Dasar
pagination:
  prev_title: OOP & Lanjutan
  prev_url: /04-oop-and-advanced/index
  next_title: Null Safety
  next_url: /04-oop-and-advanced/null-safety
---

Dart adalah bahasa berorientasi objek murni dengan dukungan class-based inheritance, mixins, dan implicit interfaces. Bab ini mencakup seluruh spektrum OOP Dart dari deklarasi class dasar hingga generics.

---

### 1. Class dan Object

Class adalah blueprint untuk membuat object. Menggunakan keyword `class`.

```dart:class_basic.dart
class Person {
  // Fields (instance variables)
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Method
  void greet() {
    print('Halo, saya $name, umur $age tahun.');
  }
}

void main() {
  // Membuat object (instance)
  var budi = Person('Budi', 25);
  var ani = Person('Ani', 22);

  budi.greet();  // Halo, saya Budi, umur 25 tahun.
  ani.greet();   // Halo, saya Ani, umur 22 tahun.
}
```

### Output

```text:output.txt
Halo, saya Budi, umur 25 tahun.
Halo, saya Ani, umur 22 tahun.
```

---

### 2. Constructor

Dart menyediakan beberapa jenis constructor.

```dart:constructors.dart
class Point {
  double x, y;

  // 1. Default constructor
  Point(this.x, this.y);

  // 2. Named constructor
  Point.origin()
      : x = 0,
        y = 0;

  // 3. Named constructor dengan initializer list
  Point.diagonal(double val)
      : x = val,
        y = val;

  // 4. Factory constructor (bisa return instance cached/subtype)
  factory Point.fromJson(Map<String, double> json) {
    return Point(json['x'] ?? 1, json['y'] ?? 1);
  }

  @override
  String toString() => 'Point($x, $y)';
}

void main() {
  var p1 = Point(3, 4);
  var p2 = Point.origin();
  var p3 = Point.diagonal(5);
  var p4 = Point.fromJson({'x': 10, 'y': 20});

  print(p1);  // Point(3.0, 4.0)
  print(p2);  // Point(0.0, 0.0)
  print(p3);  // Point(5.0, 5.0)
  print(p4);  // Point(10.0, 20.0)
}
```

### Output

```text:output.txt
Point(3.0, 4.0)
Point(0.0, 0.0)
Point(5.0, 5.0)
Point(10.0, 20.0)
```

### Constructor dengan Optional Parameters

```dart:constructor_optional.dart
class Car {
  String brand;
  String model;
  int year;

  // Optional named parameters dengan default values
  Car({
    required this.brand,   // Required — wajib diisi
    this.model = 'Unknown',
    this.year = 2026,
  });

  // Optional positional parameters
  Car.compact(this.brand, [this.model = 'Compact', this.year = 2026]);

  @override
  String toString() => '$brand $model ($year)';
}

void main() {
  var c1 = Car(brand: 'Toyota', model: 'Camry', year: 2025);
  var c2 = Car(brand: 'Honda');
  var c3 = Car.compact('Suzuki');

  print(c1);  // Toyota Camry (2025)
  print(c2);  // Honda Unknown (2026)
  print(c3);  // Suzuki Compact (2026)
}
```

### Output

```text:output.txt
Toyota Camry (2025)
Honda Unknown (2026)
Suzuki Compact (2026)
```

---

### 3. Inheritance (Pewarisan)

Gunakan keyword `extends` untuk mewarisi dari parent class. Dart mendukung single inheritance.

```dart:inheritance.dart
class Animal {
  String name;

  Animal(this.name);

  void eat() {
    print('$name sedang makan.');
  }

  void sleep() {
    print('$name sedang tidur.');
  }
}

class Cat extends Animal {
  String furColor;

  // Memanggil constructor parent dengan super
  Cat(String name, this.furColor) : super(name);

  // Override method parent
  @override
  void eat() {
    super.eat();  // Panggil method parent
    print('$name makan ikan.');
  }

  void meow() {
    print('$name: Meow!');
  }
}

void main() {
  var kucing = Cat('Milo', 'Orange');
  kucing.eat();
  kucing.sleep();
  kucing.meow();

  // Type check
  print(kucing is Animal);  // true
  print(kucing is Cat);     // true
}
```

### Output

```text:output.txt
Milo sedang makan.
Milo makan ikan.
Milo sedang tidur.
Milo: Meow!
true
true
```

---

### 4. Abstract Class

Abstract class tidak bisa diinstansiasi langsung. Berguna sebagai kontrak untuk subclass.

```dart:abstract_class.dart
abstract class Shape {
  String get name;           // Abstract getter
  double calculateArea();    // Abstract method

  // Concrete method (boleh ada implementasi)
  void display() {
    print('$name memiliki luas ${calculateArea()}');
  }
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  String get name => 'Lingkaran';

  @override
  double calculateArea() => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  double width, height;
  Rectangle(this.width, this.height);

  @override
  String get name => 'Persegi Panjang';

  @override
  double calculateArea() => width * height;
}

void main() {
  // var s = Shape();  // ERROR: abstract class tidak bisa diinstansiasi

  var shapes = [Circle(5), Rectangle(4, 6)];
  for (var shape in shapes) {
    shape.display();
  }
}
```

### Output

```text:output.txt
Lingkaran memiliki luas 78.53975
Persegi Panjang memiliki luas 24.0
```

---

### 5. Mixins

Mixins adalah cara reuse kode tanpa inheritance. Gunakan keyword `mixin`, aplikasikan dengan `with`.

```dart:mixins.dart
mixin Flyable {
  void fly() {
    print('$runtimeType terbang!');
  }
}

mixin Swimmable {
  void swim() {
    print('$runtimeType berenang!');
  }
}

class Animal {
  String name;
  Animal(this.name);
}

class Duck extends Animal with Flyable, Swimmable {
  Duck(String name) : super(name);

  void quack() {
    print('$name: Quack!');
  }
}

class Fish extends Animal with Swimmable {
  Fish(String name) : super(name);
}

void main() {
  var duck = Duck('Donald');
  duck.fly();    // Duck terbang!
  duck.swim();   // Duck berenang!
  duck.quack();  // Donald: Quack!

  var fish = Fish('Nemo');
  fish.swim();   // Fish berenang!
  // fish.fly();   // ERROR: Fish tidak punya Flyable

  print(duck is Flyable);   // true
  print(fish is Flyable);   // false
}
```

### Output

```text:output.txt
Duck terbang!
Duck berenang!
Donald: Quack!
Fish berenang!
true
false
```

---

### 6. Encapsulation (Getter & Setter)

Dart menggunakan `_` (underscore) sebagai prefix untuk private members. Public by default.

```dart:encapsulation.dart
class BankAccount {
  String _accountNumber;    // Private (underscore prefix)
  double _balance = 0;      // Private

  BankAccount(this._accountNumber);

  // Getter
  String get accountNumber => _accountNumber;
  double get balance => _balance;

  // Setter dengan validasi
  set balance(double amount) {
    if (amount >= 0) {
      _balance = amount;
    } else {
      throw ArgumentError('Saldo tidak boleh negatif');
    }
  }

  // Private method
  void _logTransaction(String type, double amount) {
    print('[$type] \$${amount.toStringAsFixed(2)} | Saldo: \$$_balance');
  }

  // Public methods yang menggunakan private method
  void deposit(double amount) {
    _balance += amount;
    _logTransaction('DEPOSIT', amount);
  }

  void withdraw(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
      _logTransaction('WITHDRAW', amount);
    } else {
      print('Saldo tidak mencukupi!');
    }
  }
}

void main() {
  var acc = BankAccount('1234567890');
  acc.deposit(1000);
  acc.withdraw(350);

  print('Akun: ${acc.accountNumber}');
  print('Saldo akhir: \$${acc.balance}');

  // acc._balance = -500;    // ERROR: private member
  // acc._logTransaction();  // ERROR: private method
}
```

### Output

```text:output.txt
[DEPOSIT] $1000.00 | Saldo: $1000.0
[WITHDRAW] $350.00 | Saldo: $650.0
Akun: 1234567890
Saldo akhir: $650.0
```

---

### 7. Generics

Generics memungkinkan type-safe collections dan class.

```dart:generics.dart
// Generic class
class Box<T> {
  T _value;

  Box(this._value);

  T get value => _value;
  set value(T newValue) => _value = newValue;

  @override
  String toString() => 'Box<$T>($_value)';
}

// Generic method
T? firstOrNull<T>(List<T> list) {
  return list.isNotEmpty ? list.first : null;
}

// Bounded type parameter (hanya num atau turunannya)
class Calculator<T extends num> {
  T a, b;
  Calculator(this.a, this.b);

  num add() => a + b;
  num multiply() => a * b;
}

void main() {
  // Box dengan int
  var intBox = Box<int>(42);
  print(intBox);                       // Box<int>(42)

  // Box dengan String
  var strBox = Box<String>('Halo');
  print(strBox);                       // Box<String>(Halo)

  // Generic method
  var nums = [1, 2, 3];
  print(firstOrNull(nums));            // 1
  print(firstOrNull(<String>[]));      // null

  // Calculator dengan bounded type
  var calcInt = Calculator<int>(10, 5);
  print('Add: ${calcInt.add()}');      // 15

  var calcDouble = Calculator<double>(3.5, 2.5);
  print('Multiply: ${calcDouble.multiply()}');  // 8.75

  // var calcStr = Calculator<String>('a', 'b'); // ERROR: String bukan num
}
```

### Output

```text:output.txt
Box<int>(42)
Box<String>(Halo)
1
null
Add: 15
Multiply: 8.75
```

---

### 8. Extension Methods

Extension menambahkan fungsionalitas baru ke class yang sudah ada tanpa memodifikasi class aslinya.

```dart:extensions.dart
// Extension pada String
extension StringExtension on String {
  String get capitalized =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  bool get isEmail => contains('@') && contains('.');

  String repeat(int n) => List.filled(n, this).join('');
}

// Extension pada int
extension IntExtension on int {
  bool get isEven => this % 2 == 0;
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
}

void main() {
  print('hello'.capitalized);     // Hello
  print('test@mail.com'.isEmail); // true
  print('Hi'.repeat(3));          // HiHiHi

  print(5.isEven);                // false
  print(5.seconds);               // 0:00:05.000000
  print(2.minutes);               // 0:02:00.000000
}
```

### Output

```text:output.txt
Hello
true
HiHiHi
false
0:00:05.000000
0:02:00.000000
```

---

### Ringkasan OOP Dart

| Konsep | Keyword | Fungsi |
|--------|---------|--------|
| Class | `class` | Blueprint object |
| Constructor | `ClassName(...)` | Inisialisasi instance |
| Inheritance | `extends` | Mewarisi dari parent |
| Abstract | `abstract class` | Kontrak tanpa implementasi |
| Mixin | `mixin` / `with` | Code reuse horizontal |
| Interface | `implements` | Kontrak implementasi |
| Encapsulation | `_member` | Private members |
| Generics | `<T>` | Type safety |
| Extension | `extension on` | Menambah fungsionalitas |