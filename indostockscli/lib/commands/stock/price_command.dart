import 'package:args/command_runner.dart';
import '../../services/api_service.dart';
import '../../utils/symbol_formatter.dart';
import '../../utils/number_formatter.dart';

class PriceCommand extends Command {
  @override
  final name = 'price';
  @override
  final description = 'Mendapatkan harga saham terkini.';
  final ApiService _apiService = ApiService();
  PriceCommand() {
    argParser.addOption(
      'symbol',
      abbr: 's',
      help: 'Simbol saham IDX, contoh: BBCA',
    );
  }

  @override
  Future<void> run() async {
    final symbolInput = argResults?['symbol'];
    if (symbolInput == null) {
      print('Harap masukkan simbol saham dengan opsi --symbol atau -s.');
      return;
    }

    final symbol = SymbolFormatter.formatSymbol(symbolInput);

    try {
      final displaySymbol = SymbolFormatter.displaySymbol(symbol);
      print('Mendapatkan harga saham untuk $displaySymbol...');
      final stock = await _apiService.fetchStockPrice(symbol);
      print('════════════════════════════════');
      print('HARGA - $displaySymbol');
      print('O : ${NumberFormatter.formatPrice(stock.priceOpen)}  H : ${NumberFormatter.formatPrice(stock.high)}');
      print('L : ${NumberFormatter.formatPrice(stock.low)}  C : ${NumberFormatter.formatPrice(stock.price)}');
      print('Change: ${NumberFormatter.formatPrice(stock.change)} (${NumberFormatter.formatChangePercent(stock.changePercent)})');
      print('Vol : ${NumberFormatter.formatVolume(stock.todayVolume)}');
      print('════════════════════════════════');

    } catch (e) {
      print('Gagal mengambil data: $e');
    }
  }
}
