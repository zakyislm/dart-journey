class Stock {
  final String symbol;
  final double price;
  final String name;
  final String description;
  final String currency;
  final String sector;
  final String marketCap;
  final double priceOpen;
  final double high;
  final double low;
  final double close;
  final double todayVolume;
  final double todayNet;
  final double change;
  final double changePercent;
  final double volume;
  final DateTime? date;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.currency,
    this.description = 'Unknown',
    this.sector = 'Unknown',
    this.marketCap = 'Unknown',
    this.priceOpen = 0.0,
    this.high = 0.0,
    this.low = 0.0,
    this.close = 0.0,
    this.todayVolume = 0.0,
    this.todayNet = 0.0,
    this.change = 0.0,
    this.changePercent = 0.0,
    this.volume = 0.0,
    this.date,
  });
  factory Stock.fromJson(Map<String, dynamic> json){
    return Stock(
      symbol: json['symbol'] ?? 'Unknown',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'Unknown',
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'IDR',
      sector: json['sector'] ?? 'Unknown',
      marketCap: json['marketCap'] ?? 'Unknown',
      priceOpen: (json['priceOpen'] ?? 0.0).toDouble(),
      high: (json['high'] ?? 0.0).toDouble(),
      low: (json['low'] ?? 0.0).toDouble(),
      close: (json['close'] ?? 0.0).toDouble(),
      todayVolume: (json['todayVolume'] ?? 0.0).toDouble(),
      todayNet: (json['todayNet'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
      changePercent: (json['changePercent'] ?? 0.0).toDouble(),
      volume: (json['volume'] ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
