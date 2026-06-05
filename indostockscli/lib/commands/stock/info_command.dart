import 'package:args/command_runner.dart';
import '../../services/api_service.dart';
import '../../utils/number_formatter.dart';
import '../../utils/symbol_formatter.dart';

class InfoCommand extends Command {
  @override
  final name = 'info';
  @override
  final description = 'Mendapatkan informasi saham.';
  final ApiService _apiService = ApiService();
  InfoCommand(){
    argParser.addOption('symbol', abbr: 's', help: 'Simbol saham IDX, contoh: BBCA');
  }
  @override
  Future<void> run() async {
    final symbolInput = argResults?['symbol'];
    final symbol = symbolInput != null ? SymbolFormatter.formatSymbol(symbolInput) : null;

    if (symbol == null) {
      print('Harap masukkan simbol saham dengan opsi --symbol atau -s.');
      return;
    }

    try {
      final stock = await _apiService.fetchStockInfo(symbol);
      final displaySymbol = SymbolFormatter.displaySymbol(stock.symbol);

      print('════════════════════════════════════════');
      print('INFO SAHAM — $displaySymbol');
      print('════════════════════════════════════════');
      print(stock.name);
      print('Sektor       : ${stock.sector}');
      print('Market Cap   : ${NumberFormatter.formatMarketCap(stock.marketCap)}\n');

      print('HARGA');
      print('Saat ini     : ${NumberFormatter.formatPrice(stock.price)}');
      print('High         : ${NumberFormatter.formatPrice(stock.high)}');
      print('Low          : ${NumberFormatter.formatPrice(stock.low)}');
      print('Close (prev) : ${NumberFormatter.formatPrice(stock.close)}\n');

      print('VOLUME       : ${NumberFormatter.formatVolume(stock.todayVolume)}');
      print('Perubahan    : ${NumberFormatter.formatChangePercent(stock.changePercent)}\n');

      print('DESKRIPSI');
      print('${stock.description}\n');
    } catch (e) {
      print('Gagal mengambil data: $e');
    }
  }
}
