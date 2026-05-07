import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/utils/base_view_model.dart';

import 'dart:async';

import '../../../core/websocket/web_socket.dart';
import '../../dashboard/viewmodel/dashboard_provider.dart';
import '../repository/repostory_detail.dart';

class DetailProvider extends BaseViewModel {

  // ── Dependencies ──────────────────────────────────────
  final DetailRepository _repo = DetailRepository();
  final WsClient _ws = WsClient();
  StreamSubscription? _subscription;

  // ── Instrument passed from list screen ────────────────
  final InstrumentModel instrument;

  // ── Chart data ────────────────────────────────────────
  List<Candle> candles = [];

  // ── Live price ────────────────────────────────────────
  double? livePrice;

  // ── Selected interval ─────────────────────────────────
  String selectedInterval = "1h";

  // ── Interval map → label to Kraken int ───────────────
  final Map<String, int> intervalMap = {
    "1m":  1,
    "5m":  5,
    "15m": 15,
    "1h":  60,
    "4h":  240,
    "1D":  1440,
    "1W":  10080,
  };

  // ── Kraken pair map → symbol to REST pair ────────────
  final Map<String, String> _restPairMap = {
    "BTCUSD": "XBTUSD",
    "ETHUSD": "ETHUSD",
    "SOLUSD": "SOLUSD",
    "XRPUSD": "XRPUSD",
    "ADAUSD": "ADAUSD",
  };

  // ── Constructor ───────────────────────────────────────
  DetailProvider({required this.instrument}) {
    init();
  }

  // ── Init ──────────────────────────────────────────────
  void init() {
    loadCandles();
    startLivePrice();
  }

  // ── Load candles from REST ────────────────────────────
  Future<void> loadCandles() async {
    setLoading();

    try {
      final pair     = _restPairMap[instrument.name] ?? instrument.name;
      final interval = intervalMap[selectedInterval] ?? 60;

      final result = await _repo.getCandles(
        pair:     pair,
        interval: interval,
      );

      // candlesticks package needs newest candle FIRST
      candles = result.reversed
          .map((c) => c.toCandle())
          .toList();

      setSuccess();

    } catch (e) {
      setError(e.toString());
      debugPrint("loadCandles error: $e");
    }
  }

  // ── Change interval ───────────────────────────────────
  void changeInterval(String interval) {
    if (selectedInterval == interval) return;
    selectedInterval = interval;
    loadCandles();  // reload candles for new interval
  }

  // ── Start live price from WebSocket ───────────────────
  void startLivePrice() {

    // WsClient is already connected from dashboard
    // Just listen to existing stream
    _subscription = _ws.priceStream.listen((data) {

      final pair = data["pair"] as String;

      // Only update if this matches our instrument
      final wsPairMap = {
        "BTCUSD": "XBT/USD",
        "ETHUSD": "ETH/USD",
        "SOLUSD": "SOL/USD",
        "XRPUSD": "XRP/USD",
        "ADAUSD": "ADA/USD",
      };

      if (pair != wsPairMap[instrument.name]) return;

      livePrice = double.tryParse(data["price"] as String);

      // Update last candle close price with live price
      if (candles.isNotEmpty && livePrice != null) {
        final last = candles.first;
        candles[0] = Candle(
          date:   last.date,
          open:   last.open,
          high:   livePrice! > last.high ? livePrice! : last.high,
          low:    livePrice! < last.low  ? livePrice! : last.low,
          close:  livePrice!,
          volume: last.volume,
        );
      }

      notifyListeners();
    });
  }

  // ── Stop live price ───────────────────────────────────
  void stopLivePrice() {
    _subscription?.cancel();
  }

  // ── Formatted live price for UI ───────────────────────
  String get displayPrice {
    if (livePrice != null) return livePrice!.toStringAsFixed(2);
    return instrument.price1;
  }

  // ── Dispose ───────────────────────────────────────────
  @override
  void dispose() {
    stopLivePrice();
    super.dispose();
  }
}