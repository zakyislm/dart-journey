---
title: Asynchronous Programming in Dart
subtitle: Future, async/await, Streams, dan Isolates untuk pemrograman asynchronous
date: 06-07-2026
language: Dart
breadcrumbs:
  - Home
  - OOP & Lanjutan
  - Asynchronous
pagination:
  prev_title: Null Safety
  prev_url: /04-oop-and-advanced/null-safety
  next_title: Ekosistem Dart
  next_url: /05-ecosystem/index
---

Dart adalah bahasa single-threaded dengan **event loop**. Untuk operasi I/O yang memakan waktu (network, file, database), Dart menggunakan pemrograman asynchronous dengan **Future**, **async/await**, dan **Streams**. Untuk komputasi berat di luar UI thread, Dart menyediakan **Isolates**.

---

### 1. Future

`Future<T>` merepresentasikan nilai yang akan tersedia nanti (atau error). Analog dengan Promise di JavaScript.

```dart:future_basic.dart
void main() {
  // Membuat Future
  Future<String> fetchData() {
    return Future.delayed(
      Duration(seconds: 2),
      () => 'Data berhasil diambil',
    );
  }

  // Mengkonsumsi Future dengan then/catchError
  fetchData().then((value) {
    print('Success: $value');
  }).catchError((error) {
    print('Error: $error');
  });

  print('Menunggu data...');
}
```

### Output

```text:output.txt
Menunggu data...
Success: Data berhasil diambil
```

---

### 2. Async / Await

`async` dan `await` membuat kode asynchronous terlihat seperti synchronous.

```dart:async_await.dart
// Simulasi API call
Future<String> getUser() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Budi';
}

Future<int> getScore(String user) async {
  await Future.delayed(Duration(milliseconds: 500));
  return 95;
}

// Menggabungkan dengan async/await
Future<void> loadUserProfile() async {
  print('Loading...');

  try {
    String user = await getUser();
    print('User: $user');

    int score = await getScore(user);
    print('Score: $score');

    print('Profile loaded!');
  } catch (e) {
    print('Error: $e');
  }
}

void main() async {
  await loadUserProfile();
  print('Done');
}
```

### Output

```text:output.txt
Loading...
User: Budi
Score: 95
Profile loaded!
Done
```

---

### 3. Multiple Futures (Parallel vs Sequential)

```dart:multiple_futures.dart
Future<String> fetchA() async {
  await Future.delayed(Duration(seconds: 1));
  return 'A';
}

Future<String> fetchB() async {
  await Future.delayed(Duration(seconds: 1));
  return 'B';
}

void main() async {
  // Sequential — total ~2 detik
  var sw = Stopwatch()..start();
  var a = await fetchA();
  var b = await fetchB();
  print('Sequential: $a $b — ${sw.elapsedMilliseconds}ms');
  sw.stop();

  // Parallel — total ~1 detik
  sw = Stopwatch()..start();
  var results = await Future.wait([fetchA(), fetchB()]);
  print('Parallel: ${results.join(' ')} — ${sw.elapsedMilliseconds}ms');
  sw.stop();

  // Future.any — return yang paling cepat
  var first = await Future.any([
    Future.delayed(Duration(seconds: 2), () => 'Slow'),
    Future.delayed(Duration(milliseconds: 300), () => 'Fast'),
  ]);
  print('First: $first');
}
```

### Output

```text:output.txt
Sequential: A B — 2002ms
Parallel: A B — 1001ms
First: Fast
```

---

### 4. Error Handling

```dart:async_error_handling.dart
Future<String> riskyOperation(bool fail) async {
  await Future.delayed(Duration(seconds: 1));
  if (fail) {
    throw Exception('Operasi gagal!');
  }
  return 'Operasi berhasil!';
}

void main() async {
  // Try-catch dengan async/await
  try {
    var result = await riskyOperation(true);
    print(result);
  } catch (e) {
    print('Caught: $e');
  }

  // then/catchError
  riskyOperation(false).then((r) {
    print('Then: $r');
  }).catchError((e) {
    print('Error: $e');
  }).whenComplete(() {
    print('Selesai (selalu dijalankan)');
  });
}
```

### Output

```text:output.txt
Caught: Exception: Operasi gagal!
Then: Operasi berhasil!
Selesai (selalu dijalankan)
```

---

### 5. Streams

Stream adalah sequence dari event asynchronous — seperti Future tapi bisa mengirim banyak nilai.

```dart:stream_basic.dart
void main() async {
  // Membuat Stream
  Stream<int> countStream(int max) async* {
    for (int i = 1; i <= max; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      yield i;  // Kirim nilai ke stream
    }
  }

  // Konsumsi Stream — await for
  print('Counting...');
  await for (var value in countStream(3)) {
    print('Count: $value');
  }

  // Konsumsi Stream — listen
  countStream(2).listen(
    (value) {
      print('Listen: $value');
    },
    onDone: () {
      print('Stream selesai!');
    },
    onError: (error) {
      print('Error: $error');
    },
  );
}
```

### Output

```text:output.txt
Counting...
Count: 1
Count: 2
Count: 3
Listen: 1
Listen: 2
Stream selesai!
```

---

### 6. Stream Transformations

```dart:stream_transformation.dart
Stream<int> numberGenerator() async* {
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield i;
  }
}

void main() async {
  var stream = numberGenerator();

  // Pipe transformations
  var result = stream
      .where((n) => n % 2 == 0)       // Filter even
      .map((n) => n * n)              // Kuadratkan
      .take(3);                       // Ambil 3 first

  await for (var value in result) {
    print('Result: $value');
  }

  // Stream subscription
  var sub = numberGenerator().listen(null);
  sub.onData((data) {
    print('Data: $data');
    if (data >= 3) sub.cancel();       // Stop setelah 3
  });
}
```

### Output

```text:output.txt
Result: 4
Result: 16
Result: 36
Data: 1
Data: 2
Data: 3
```

---

### 7. StreamController

```dart:stream_controller.dart
import 'dart:async';

void main() {
  // StreamController — kontrol penuh
  var controller = StreamController<String>();

  // Mendengarkan stream
  controller.stream.listen(
    (data) => print('Received: $data'),
    onDone: () => print('Stream closed'),
    onError: (e) => print('Error: $e'),
  );

  // Mengirim data
  controller.add('Pesan 1');
  controller.add('Pesan 2');
  controller.add('Pesan 3');
  controller.close();

  // Broadcast stream (multiple listeners)
  var broadcastController = StreamController<int>.broadcast();

  broadcastController.stream.listen((n) => print('Listener 1: $n'));
  broadcastController.stream.listen((n) => print('Listener 2: $n'));

  broadcastController.add(42);
  broadcastController.close();
}
```

### Output

```text:output.txt
Received: Pesan 1
Received: Pesan 2
Received: Pesan 3
Stream closed
Listener 1: 42
Listener 2: 42
```

---

### 8. Isolates

Isolates adalah unit concurrency Dart — setiap isolate punya memory sendiri yang terisolasi (no shared memory). Gunakan untuk komputasi berat tanpa memblokir UI.

```dart:isolate_basic.dart
import 'dart:isolate';

// Fungsi yang berjalan di isolate terpisah
void heavyComputation(SendPort sendPort) {
  // Komputasi berat — menghitung bilangan prima
  int countPrimes(int max) {
    int count = 0;
    for (int i = 2; i <= max; i++) {
      bool isPrime = true;
      for (int j = 2; j <= i ~/ 2; j++) {
        if (i % j == 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) count++;
    }
    return count;
  }

  var result = countPrimes(50000);
  sendPort.send(result);  // Kirim hasil kembali ke main isolate
}

void main() async {
  print('Memulai komputasi berat...');

  // Buat ReceivePort untuk menerima hasil
  var receivePort = ReceivePort();

  // Spawn isolate baru
  await Isolate.spawn(heavyComputation, receivePort.sendPort);

  // Terima hasil
  var primes = await receivePort.first;
  print('Jumlah bilangan prima ≤ 50000: $primes');
  print('Selesai — UI tidak freeze!');
}
```

### Output

```text:output.txt
Memulai komputasi berat...
Jumlah bilangan prima ≤ 50000: 5133
Selesai — UI tidak freeze!
```

---

### Ringkasan Asynchronous Dart

| Konsep | Keyword/Tipe | Digunakan untuk |
|--------|--------------|----------------|
| Future | `Future<T>` | Single async value |
| Async/Await | `async`, `await` | Kode async seperti sync |
| Stream | `Stream<T>`, `async*`, `yield` | Sequence async values |
| StreamController | `StreamController<T>` | Kontrol manual stream |
| Future.wait | `Future.wait([])` | Parallel futures |
| Future.any | `Future.any([])` | Fastest future |
| Isolate | `Isolate.spawn()` | Concurrency tanpa shared memory |
| ReceivePort | `ReceivePort` | Komunikasi antar isolate |