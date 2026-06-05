import 'package:args/command_runner.dart';
import '../../utils/storage_helper.dart';
import '../../services/api_service.dart';
import '../../utils/number_formatter.dart';
import '../../utils/symbol_formatter.dart';

class ListCommand extends Command {
  @override
  final name = 'list';
  @override
  final description = 'Menampilkan daftar saham yang ada di watchlist.';
  final StorageHelper _storage = StorageHelper();
  final ApiService _apiService = ApiService();
  
  ListCommand(){
    argParser.addOption('symbol', abbr: 's', help: 'Simbol saham yang ingin ditambahkan ke watchlist');
  }
  
  @override
  Future<void> run() async {
    try {
      final watchlist = await _storage.getWatchlist();
      
      if (watchlist.isEmpty) {
        print('Watchlist Anda kosong.');
        return;
      }
      
      print('Watchlist Saham');
      print('================\n');
      
      for (final symbol in watchlist) {
        try {

          final code = SymbolFormatter.formatSymbol(symbol);
          final stock = await _apiService.fetchStockPrice(code);
          final displaySymbol = SymbolFormatter.displaySymbol(code);
          final price = NumberFormatter.formatPrice(stock.price);
          final changePct = NumberFormatter.formatChangePercent(stock.changePercent);
          final volume = NumberFormatter.formatVolume(stock.todayVolume);

          print('$displaySymbol | ${stock.name}');
          print('Price: $price ($changePct) | Vol: $volume | Sector: ${stock.sector}');

        } catch (e) {
          print('$symbol - Error: Gagal mengambil data');
        }
        print('');
      }
      
    } catch (e) {
      print('Gagal mengambil watchlist: $e');
    }
  }
}