import 'package:args/command_runner.dart';
import '../../utils/storage_helper.dart';
import '../../utils/symbol_formatter.dart';

class AddCommand extends Command {
  @override
  final name = 'add';
  @override
  final description = 'Menambahkan saham ke watchlist.';
  final StorageHelper _storage = StorageHelper();
  AddCommand(){
    argParser.addOption('symbol', abbr: 's', help: 'Simbol saham yang ingin ditambahkan ke watchlist');
  }

  @override
  Future<void> run() async {
    final symbolInput = argResults!.rest.isNotEmpty ? argResults!.rest.first : null;
    if(symbolInput == null) {
      print('Harap masukkan simbol saham yang ingin ditambahkan ke watchlist.');
      return;
    }
    final symbol = SymbolFormatter.formatSymbol(symbolInput);
    final list = await _storage.getWatchlist();
    if(!list.contains(symbol)) {
      list.add(symbol);
      await _storage.saveWatchlist(list);
      print('Saham $symbol berhasil ditambahkan ke watchlist.');
    } else {
      print('Saham $symbol sudah ada di watchlist.');
    }
  }
}