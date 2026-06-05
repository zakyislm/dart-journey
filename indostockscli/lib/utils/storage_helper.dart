import 'dart:io';
import 'dart:convert';

class StorageHelper {
  final File _file = File('watchlist.json');

  Future<void> saveWatchlist(List<String> symbols) async {
    final jsonString = jsonEncode(symbols);
    await _file.writeAsString(jsonString);
  }
  Future<List<String>> getWatchlist() async {
    if (!await _file.exists()) {
      return [];
    }
    try {
      final content = await _file.readAsString();
      final dynamic decoded = jsonDecode(content);
      if(decoded is List){
        return List<String>.from(decoded);
      }
      return [];

    } catch (e) {
      print('Error reading watchlist: $e');
      return [];
    }

  }
}