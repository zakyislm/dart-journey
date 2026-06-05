import 'package:args/command_runner.dart';

import '../../../models/stock_models.dart';
import '../../../services/api_service.dart';
import '../../../utils/number_formatter.dart';
import '../../../utils/symbol_formatter.dart';

class HistoryCommand extends Command {
  @override
  final name = 'history';
  @override
  final description = 'Mendapatkan riwayat harga saham.';
  final ApiService _apiService = ApiService();

  HistoryCommand() {
    argParser.addOption(
      'symbol',
      abbr: 's',
      help: 'Simbol saham IDX, contoh: BBCA',
      defaultsTo: 'BBCA',
    );
    argParser.addOption(
      'days',
      abbr: 'd',
      help: 'Jumlah hari riwayat harga yang ingin ditampilkan.',
      defaultsTo: '7',
    );
  }

  @override
  Future<void> run() async {
    final symbolInput = _readSymbolInput();
    final days = _readDays();

    if (days == null) {
      print('Jumlah hari harus berupa angka lebih dari 0.');
      return;
    }

    final symbol = SymbolFormatter.formatSymbol(symbolInput);
    print(
      'Mendapatkan riwayat harga saham untuk $symbol selama $days hari terakhir...',
    );

    try {
      final history = await _apiService.fetchStockHistory(symbol, days);

      if (history.isEmpty) {
        print('Tidak ada data riwayat harga untuk $symbol.');
        return;
      }

      _printHistory(symbol, history);
    } catch (e) {
      print('Gagal mengambil data: $e');
    }
  }

  String _readSymbolInput() {
    final positionalSymbol = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : null;
    return positionalSymbol ?? argResults?['symbol'] ?? 'BBCA';
  }

  int? _readDays() {
    final days = int.tryParse(argResults?['days'] ?? '');
    if (days == null || days <= 0) {
      return null;
    }

    return days;
  }

  void _printHistory(String symbol, List<Stock> history) {
    print('Riwayat harga saham $symbol:');
    print('Tanggal      O          H          L          C          Vol');

    for (final stock in history) {
      final dateText = stock.date != null
          ? stock.date!.toIso8601String().split('T').first
          : 'Unknown';
      final open = NumberFormatter.formatPrice(stock.priceOpen).padLeft(10);
      final high = NumberFormatter.formatPrice(stock.high).padLeft(10);
      final low = NumberFormatter.formatPrice(stock.low).padLeft(10);
      final close = NumberFormatter.formatPrice(stock.price).padLeft(10);
      final volume = NumberFormatter.formatVolume(stock.todayVolume).padLeft(10);

      print('$dateText $open $high $low $close $volume');
    }
  }
}
