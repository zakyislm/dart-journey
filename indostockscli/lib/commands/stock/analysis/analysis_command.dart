import 'package:args/command_runner.dart';
import '../../../models/stock_models.dart';
import '../../../services/api_service.dart';
import '../../../utils/technical_analyzer.dart';
import '../../../utils/symbol_formatter.dart';
import '../../../utils/number_formatter.dart';

class AnalysisCommand extends Command {
  @override
  final name = 'analysis';
  @override
  final description = 'Analisis teknikal lengkap (RSI, MACD, Support/Resistance).';
  final ApiService _apiService = ApiService();

  AnalysisCommand() {
    argParser.addOption('symbol', abbr: 's', help: 'Simbol saham untuk dianalisa');
    argParser.addOption('days',
        abbr: 'd',
        help: 'Jumlah hari data historis untuk analisis (minimal 30)',
        defaultsTo: '60');
  }

  @override
  Future<void> run() async {
    final symbolInput = argResults?['symbol'];
    final daysInput = argResults?['days'] ?? '60';
    final days = int.tryParse(daysInput);

    if (symbolInput == null) {
      print('Harap masukkan simbol saham dengan opsi --symbol atau -s.');
      return;
    }

    if (days == null || days <= 0) {
      print('Jumlah hari harus berupa angka lebih dari 0.');
      return;
    }

    final symbol = SymbolFormatter.formatSymbol(symbolInput);

    try {
      print('Menganalisis saham ${SymbolFormatter.displaySymbol(symbol)}...\n');

      final results = await Future.wait<Object>([
        _apiService.fetchStockPrice(symbol),
        _apiService.fetchStockHistory(symbol, days),
      ]);
      final stock = results[0] as Stock;
      final history = results[1] as List<Stock>;

      if (history.isEmpty) {
        print('Tidak ada data historis untuk analisis.');
        return;
      }

      // Extract closes for RSI and MACD
      List<double> closes = history.map((s) => s.price).toList();

      // Calculate indicators
      double rsi = TechnicalAnalyzer.calculateRSI(closes);
      Map<String, double> macd = TechnicalAnalyzer.calculateMACD(closes);
      Map<String, double> levels =
          TechnicalAnalyzer.calculateSupportResistance(history);
      String volumeAnalysis = TechnicalAnalyzer.analyzeVolume(history);

      // Display analysis
      print('═══════════════════════════════════════');
      print('ANALISIS TEKNIKAL - ${SymbolFormatter.displaySymbol(symbol)}');
      print('═══════════════════════════════════════\n');

      print('📊 INFO SAHAM');
      print('Nama: ${stock.name}');
      print('Harga Saat Ini: ${NumberFormatter.formatPrice(stock.price)}');
      print('Sektor: ${stock.sector}\n');

      print('📈 MOMENTUM INDICATORS');
      print('RSI (14): ${rsi.toStringAsFixed(2)}');
      print('Status RSI: ${TechnicalAnalyzer.getRSIInterpretation(rsi)}');
      print('');

      print('📊 TREND INDICATORS');
      print('MACD: ${macd['macd']!.toStringAsFixed(5)}');
      print('Signal: ${macd['signal']!.toStringAsFixed(5)}');
      print('Histogram: ${macd['histogram']!.toStringAsFixed(5)}');
      print('Status MACD: ${TechnicalAnalyzer.getMACDInterpretation(macd)}\n');

      print('🎯 SUPPORT & RESISTANCE');
      print(
          'Resistance: ${NumberFormatter.formatPrice(levels['resistance']!)}');
      print('Pivot Point: ${NumberFormatter.formatPrice(levels['pivot']!)}');
      print('Support: ${NumberFormatter.formatPrice(levels['support']!)}');
      print('');

      print('📉 VOLUME ANALYSIS');
      print('Volume Hari Ini: $volumeAnalysis\n');

      print('═══════════════════════════════════════');
      _printRecommendation(rsi, macd);
      print('═══════════════════════════════════════');
    } catch (e) {
      print('Gagal menganalisis: $e');
    }
  }

  void _printRecommendation(double rsi, Map<String, double> macd) {
    List<String> signals = [];

    if (rsi > 70) {
      signals.add('⚠️ RSI menunjukkan Overbought - Pertimbangkan untuk menjual');
    } else if (rsi < 30) {
      signals.add('✅ RSI menunjukkan Oversold - Peluang pembelian');
    }

    String macdStatus = TechnicalAnalyzer.getMACDInterpretation(macd);
    if (macdStatus.contains('Bullish')) {
      signals.add('✅ MACD memberikan sinyal Bullish');
    } else if (macdStatus.contains('Bearish')) {
      signals.add('⚠️ MACD memberikan sinyal Bearish');
    }

    if (signals.isEmpty) {
      print('💡 REKOMENDASI: Kondisi pasar netral, tunggu sinyal yang lebih jelas.');
    } else {
      print('💡 REKOMENDASI:');
      for (String signal in signals) {
        print(signal);
      }
    }
  }
}
