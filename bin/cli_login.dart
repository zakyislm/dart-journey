import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart';
import 'dart:io';

Future<void> main() async {
  var env = DotEnv()..load(['.env']);
  final String dbHost = env['DB_HOST'] ?? 'localhost';
  final int dbPort = int.tryParse(env['DB_PORT'] ?? '3306') ?? 3306;
  final String dbUser = env['DB_USER'] ?? ''; 
  final String dbPassword = env['DB_PASSWORD'] ?? '';
  final String dbName = env['DB_NAME'] ?? '';
  print('Connected to the database.');
  final projectSettings = ConnectionSettings(
    host: dbHost,
    port: dbPort,
    user: dbUser,
    password: dbPassword,
    db: dbName,
  );
  print("Trying to login with ""$dbUser");
  try {
    final conn = await MySqlConnection.connect(projectSettings);
    print('Login successful!');
    await conn.query('''
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      password VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL
    )
''');
    bool running = true;
    while(running){
      print('Welcome to the user management system!');
      print('Please login/register to continue.');
      print('1. Login');
      print('2. Register');
      print('3. Exit');
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          await handleLogin(conn);
          break;
        case '2':
          await handleRegistration(conn);
          break;
        case '3':
          print('Exiting the application. Goodbye!');
          running = false;
          break;
        default:
          print('Invalid choice. Please try again.');
      }

    }
    await conn.close();
  } catch (e) {
    print('Error Details: $e');
  }
}
// Regist Function
Future<void> handleRegistration(MySqlConnection conn) async{
  print('\n--- Register a New Account ---');
  stdout.write('Enter username (max 12 characters): ');

  String username = stdin.readLineSync() ?? '';
  if(username.isEmpty || username.length > 12){
    print('Username must be 1-12 characters or less. Please try again.');
    return;
  }
  stdout.write('Enter password: ');
  String password = stdin.readLineSync() ?? '';
  if(password.isEmpty){
    print('Password cannot be empty. Please try again.');
    return;
  }
  stdout.write('Enter email: ');
  String email = stdin.readLineSync() ?? '';
  if((email.isEmpty || !email.contains('@') || email.length < 5) ){
    print('Invalid email format. Please try again.');
    return;
  }
  try {
    var result = await conn.query(
      'INSERT INTO users (username, password, email) VALUES (?, ?, ?)',
      [username, password, email],
    );
    print('Registration successful! Your user ID is ${result.insertId}.');
  } catch (e) {
    if (e.toString().contains('Duplicate entry')) {
      print('Username or email already exists. Please try again with different credentials.');
    } else {
      print('Error during registration: $e');
    }
  }
}

Future<void> handleLogin(MySqlConnection conn) async{
  print('\n--- Use your credentials to login ---');
  stdout.write('Enter username: ');
  String username = stdin.readLineSync() ?? '';
  
  stdout.write('Enter password: ');
  String password = stdin.readLineSync() ?? '';

  try {
    var results = await conn.query(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, password],
    );
    if(results.isNotEmpty){
      var userRow = results.first;
      print('Login successful! Welcome, ${userRow['username']}!');
      print('Your email: ${userRow['email']}');
    } else {
      print('Login failed. Invalid username or password.');
    }
  } catch (e) {
    print('Error during login: $e');
  }
}