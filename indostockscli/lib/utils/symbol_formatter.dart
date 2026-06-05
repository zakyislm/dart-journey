class SymbolFormatter {
  /// Normalizes symbol for API use (removes .JK suffix if present).
  /// If symbol doesn't have .JK, adds it automatically.
  static String formatSymbol(String symbol) {
    final trimmed = symbol.trim().toUpperCase();
    if (!trimmed.contains('.')) {
      // No dot, so auto-add .JK then normalize
      return trimmed;
    }
    // Remove .JK suffix for API
    return trimmed.endsWith('.JK') ? trimmed.substring(0, trimmed.length - 3) : trimmed;
  }

  /// Returns a display-friendly symbol, ensuring the .JK suffix is present.
  static String displaySymbol(String symbol) {
    final normalized = formatSymbol(symbol);
    return '$normalized.JK';
  }
}
