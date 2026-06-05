import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/stock_models.dart';

class ApiService {
  static const _baseUrl = 'https://www.idx.co.id';
  static const _defaultHeaders = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.9,id;q=0.8',
    'Referer': 'https://www.idx.co.id/',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest',
  };

  final http.Client _client;
  String? _sessionCookie;
  Future<void>? _sessionFuture;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Stock> fetchStockPrice(String symbol) async {
    final code = _normalizeSymbol(symbol);
    final data = await _fetchTradingInfoDaily(code);
    final stock = _stockFromTradingDaily(code, data);

    if (stock == null) {
      throw Exception('Failed to load stock data');
    }

    return stock;
  }

  Future<Stock> fetchStockInfo(String symbol) async {
    final code = _normalizeSymbol(symbol);
    final profile = await _fetchCompanyProfileDetail(code);
    final data = await _fetchTradingInfoDaily(code);
    final stock = _stockFromTradingDaily(code, data, profile: profile);

    if (stock == null) {
      throw Exception('Failed to load stock info');
    }

    return stock;
  }

  Future<List<Stock>> fetchStockHistory(String symbol, int days) async {
    final code = _normalizeSymbol(symbol);
    final url = Uri.parse(
      '$_baseUrl/primary/ListedCompany/GetTradingInfoSS?code=$code&start=0&length=$days',
    );
    final data = await _getJson(url);

    final replies = data['replies'];
    if (replies is! List) {
      throw Exception('Failed to load stock history');
    }

    return replies
        .map((item) => _stockFromTradingHistory(code, item))
        .whereType<Stock>()
        .toList()
        .reversed
        .toList();
  }

  Future<Map<String, dynamic>?> _fetchTradingInfoDaily(String code) async {
    final url = Uri.parse(
      '$_baseUrl/primary/ListedCompany/GetTradingInfoDaily?code=$code',
    );
    final data = await _getJson(url);

    if (data['SecurityCode'] == null) {
      return null;
    }

    return data;
  }

  Future<Map<String, dynamic>?> _fetchCompanyProfileDetail(String code) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/primary/ListedCompany/GetCompanyProfilesDetail?KodeEmiten=$code&language=id-id',
      );
      final data = await _getJson(url);
      final profiles = data['Profiles'];

      if (profiles is! List || profiles.isEmpty || profiles.first is! Map) {
        return null;
      }

      return Map<String, dynamic>.from(profiles.first as Map);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri url) async {
    await _ensureSession();
    final response = await _request(url);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('IDX API returned HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception('IDX API returned an unexpected response');
  }

  Future<void> _ensureSession() async {
    if (_sessionCookie != null) {
      return;
    }

    _sessionFuture ??= _openSession();
    await _sessionFuture;
  }

  Future<void> _openSession() async {
    final response = await _request(Uri.parse('$_baseUrl/id'), useCookie: false);
    _sessionCookie = response.headers['set-cookie'] ?? '';
  }

  Future<http.Response> _request(
    Uri url, {
    bool useCookie = true,
    int maxAttempts = 3,
  }) async {
    Object? lastError;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final headers = Map<String, String>.from(_defaultHeaders);
        final cookie = _sessionCookie;
        if (useCookie && cookie != null && cookie.isNotEmpty) {
          headers['Cookie'] = cookie;
        }

        final response = await _client
            .get(url, headers: headers)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode < 500) {
          return response;
        }

        lastError = Exception(
          'IDX API returned HTTP ${response.statusCode}',
        );
      } catch (error) {
        lastError = error;
      }

      if (attempt < maxAttempts) {
        final delayMs =
            (1000 * (1 << (attempt - 1))).clamp(1000, 15000).toInt();
        final delay = Duration(
          milliseconds: delayMs,
        );
        await Future<void>.delayed(delay);
      }
    }

    throw Exception('Failed to connect to IDX API: $lastError');
  }

  Stock? _stockFromTradingDaily(
    String code,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? profile,
  }) {
    if (data == null) {
      return null;
    }

    final previous = _toDouble(data['PreviousPrice']);
    final close = _toDouble(data['ClosingPrice']);
    final change = _toDouble(data['Change']);
    final changePercent = previous == 0 ? 0.0 : (change / previous) * 100;

    return Stock(
      symbol: code,
      name: _asString(profile?['NamaEmiten']) ??
          _asString(data['CompanyName']) ??
          code,
      description: _asString(profile?['KegiatanUsahaUtama']) ?? 'Unknown',
      price: close,
      currency: 'IDR',
      sector: _asString(profile?['Sektor']) ?? 'Unknown',
      marketCap: _formatMarketCap(
        close,
        _toDouble(data['ListedShares']),
      ),
      priceOpen: _toDouble(data['OpeningPrice']),
      high: _toDouble(data['HighestPrice']),
      low: _toDouble(data['LowestPrice']),
      close: previous,
      todayVolume: _toDouble(data['TradedVolume']),
      todayNet: change,
      change: change,
      changePercent: changePercent,
      volume: _toDouble(data['TradedVolume']),
    );
  }

  Stock? _stockFromTradingHistory(String code, dynamic item) {
    if (item is! Map) {
      return null;
    }

    final data = Map<String, dynamic>.from(item);
    return Stock(
      symbol: _asString(data['StockCode']) ?? code,
      name: _asString(data['StockName']) ?? code,
      price: _toDouble(data['Close']),
      priceOpen: _toDouble(data['OpenPrice']),
      high: _toDouble(data['High']),
      low: _toDouble(data['Low']),
      close: _toDouble(data['Previous']),
      sector: 'Unknown',
      currency: 'IDR',
      todayVolume: _toDouble(data['Volume']),
      volume: _toDouble(data['Volume']),
      change: _toDouble(data['Change']),
      todayNet: _toDouble(data['Change']),
      date: _parseDate(data['Date']),
    );
  }

  String _normalizeSymbol(String symbol) {
    final trimmed = symbol.trim().toUpperCase();
    return trimmed.endsWith('.JK')
        ? trimmed.substring(0, trimmed.length - 3)
        : trimmed;
  }

  String _formatMarketCap(double price, double shares) {
    final marketCap = price * shares;
    if (marketCap <= 0) {
      return 'Unknown';
    }

    return marketCap.toStringAsFixed(0);
  }

  DateTime? _parseDate(dynamic value) {
    final text = _asString(value);
    if (text == null || text.isEmpty) {
      return null;
    }

    return DateTime.tryParse(text);
  }

  String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    }

    return 0.0;
  }
}
