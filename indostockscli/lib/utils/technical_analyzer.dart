import '../models/stock_models.dart';

class TechnicalAnalyzer {
  static double calculateRSI(List<double> closes, {int period = 14}) {
    if (closes.length < period + 1) {
      return 0.0;
    }

    List<double> changes = [];
    for (int i = 1; i < closes.length; i++) {
      changes.add(closes[i] - closes[i - 1]);
    }

    double gains = 0;
    double losses = 0;

    for (int i = 0; i < period; i++) {
      if (changes[i] > 0) {
        gains += changes[i];
      } else {
        losses += (changes[i] * -1);
      }
    }

    double avgGain = gains / period;
    double avgLoss = losses / period;

    for (int i = period; i < changes.length; i++) {
      if (changes[i] > 0) {
        avgGain = (avgGain * (period - 1) + changes[i]) / period;
        avgLoss = (avgLoss * (period - 1)) / period;
      } else {
        avgGain = (avgGain * (period - 1)) / period;
        avgLoss = (avgLoss * (period - 1) + (changes[i] * -1)) / period;
      }
    }

    if (avgLoss == 0) {
      return 100.0;
    }

    double rs = avgGain / avgLoss;
    double rsi = 100 - (100 / (1 + rs));

    return rsi;
  }

  // Calculate MACD (Moving Average Convergence Divergence)
  static Map<String, double> calculateMACD(List<double> closes,
      {int fast = 12, int slow = 26, int signal = 9}) {
    if (closes.length < slow) {
      return {'macd': 0.0, 'signal': 0.0, 'histogram': 0.0};
    }

    List<double> ema12 = _calculateEMA(closes, fast);
    List<double> ema26 = _calculateEMA(closes, slow);

    int minLength = ema26.length < ema12.length ? ema26.length : ema12.length;
    List<double> macdLine = [];
    for (int i = 0; i < minLength; i++) {
      macdLine.add(ema12[i] - ema26[i]);
    }

    if (macdLine.isEmpty) {
      return {'macd': 0.0, 'signal': 0.0, 'histogram': 0.0};
    }

    List<double> signalLine = _calculateEMA(macdLine, signal);
    double currentMACD = macdLine.last;
    double currentSignal = signalLine.isNotEmpty ? signalLine.last : currentMACD;
    double histogram = currentMACD - currentSignal;

    return {
      'macd': currentMACD,
      'signal': currentSignal,
      'histogram': histogram,
    };
  }

  static List<double> _calculateEMA(List<double> data, int period) {
    if (data.length < period) {
      return data; // Return original data if not enough points
    }
    
    List<double> ema = [];
    double multiplier = 2 / (period + 1);

    // Calculate SMA first
    double sma = data.sublist(0, period).reduce((a, b) => a + b) / period;
    ema.add(sma);

    // Calculate EMA
    for (int i = period; i < data.length; i++) {
      double currentEMA = (data[i] - ema.last) * multiplier + ema.last;
      ema.add(currentEMA);
    }

    return ema;
  }

  // Calculate Support and Resistance levels
  static Map<String, double> calculateSupportResistance(
      List<Stock> history) {
    if (history.isEmpty) {
      return {'support': 0.0, 'resistance': 0.0};
    }

    double highest = history.map((s) => s.high).reduce((a, b) => a > b ? a : b);
    double lowest = history.map((s) => s.low).reduce((a, b) => a < b ? a : b);

    double resistance = highest;
    double support = lowest;

    return {
      'support': support,
      'resistance': resistance,
      'pivot': (highest + lowest + history.last.price) / 3,
    };
  }

  // Analyze volume trend
  static String analyzeVolume(List<Stock> history) {
    if (history.length < 2) {
      return 'Data tidak cukup';
    }

    double avgVolume =
        history.map((s) => s.todayVolume).reduce((a, b) => a + b) /
            history.length;
    double currentVolume = history.last.todayVolume;

    if (currentVolume > avgVolume * 1.5) {
      return 'Tinggi (${(currentVolume / 1e6).toStringAsFixed(2)}M)';
    } else if (currentVolume < avgVolume * 0.5) {
      return 'Rendah (${(currentVolume / 1e6).toStringAsFixed(2)}M)';
    } else {
      return 'Normal (${(currentVolume / 1e6).toStringAsFixed(2)}M)';
    }
  }

  // Get RSI interpretation
  static String getRSIInterpretation(double rsi) {
    if (rsi > 70) {
      return 'Overbought (Indikasi penjualan)';
    } else if (rsi < 30) {
      return 'Oversold (Indikasi pembelian)';
    } else {
      return 'Netral';
    }
  }

  // Get MACD interpretation
  static String getMACDInterpretation(Map<String, double> macd) {
    double histogram = macd['histogram'] ?? 0.0;
    double macdValue = macd['macd'] ?? 0.0;
    double signal = macd['signal'] ?? 0.0;

    if (histogram > 0 && macdValue > signal) {
      return 'Bullish (Sinyal Beli)';
    } else if (histogram < 0 && macdValue < signal) {
      return 'Bearish (Sinyal Jual)';
    } else {
      return 'Netral';
    }
  }
}
