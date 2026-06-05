class NumberFormatter {
  static String formatMarketCap(dynamic value) {
    if (value is String) {
      // If it's already a formatted string like "1.2T", return as-is
      if (value.contains(RegExp(r'[KMBTk]$'))) {
        return value;
      }
      // Try to parse string to double
      final parsed = double.tryParse(value);
      if (parsed == null) {
        return value; // Return original if can't parse
      }
      return _formatNumber(parsed);
    } else if (value is num) {
      return _formatNumber(value.toDouble());
    }
    return 'Unknown';
  }

  static String _formatNumber(double value) {
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    } else if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }

  static String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  static String formatVolume(double volume) {
    if (volume >= 1e9) {
      return '${(volume / 1e9).toStringAsFixed(2)}B';
    } else if (volume >= 1e6) {
      return '${(volume / 1e6).toStringAsFixed(2)}M';
    } else if (volume >= 1e3) {
      return '${(volume / 1e3).toStringAsFixed(2)}K';
    }
    return volume.toStringAsFixed(0);
  }

  static String formatChangePercent(double percent) {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }
}
