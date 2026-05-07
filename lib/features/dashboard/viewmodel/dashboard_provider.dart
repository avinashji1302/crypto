// import 'package:app/core/utils/base_view_model.dart';
//
// class DashboardProvider extends BaseViewModel {
//
//   int categoryIndex = 0;
//
//   final List<String> tabs = ["All", "Forex", "Crypto", "Indices", "Stocks"];
//   final instruments = [
//     {
//       "name": "BTCUSD",
//       "price1": "80877.50",
//       "price2": "80911.50",
//       "change": "-0.67%",
//       "isUp": false,
//       "type": "crypto",
//     },
//     {
//       "name": "ETHUSD",
//       "price1": "2323.18",
//       "price2": "2325.83",
//       "change": "-1.13%",
//       "isUp": false,
//       "type": "crypto",
//     },
//     {
//       "name": "EURUSD",
//       "price1": "1.17512",
//       "price2": "1.17524",
//       "change": "+0.03%",
//       "isUp": true,
//       "type": "forex",
//     },
//     {
//       "name": "XAUUSD",
//       "price1": "4698.20",
//       "price2": "4698.63",
//       "change": "-0.01%",
//       "isUp": false,
//       "type": "indices",
//     },
//   ];
//
//
//   List<Map<String, dynamic>> get filteredList {
//     if (categoryIndex == 0) return instruments;
//     final type = tabs[categoryIndex].toLowerCase();
//     return instruments.where((e) => e.containsKey("type") && e["type"] == type).toList();
//   }
//   void changeCategory(int index) {
//
//     if (categoryIndex == index) return;
//
//     categoryIndex = index;
//
//    notifyListeners();
//   }
// }

import 'package:flutter/cupertino.dart';

import '../../../core/utils/base_view_model.dart';
import '../../../core/websocket/web_socket.dart';
import 'dart:async';


// features/dashboard/viewmodel/dashboard_provider.dart



class DashboardProvider extends BaseViewModel {

  // ── Dependencies ────────────────────────────────────────
  final WsClient _ws = WsClient();
  StreamSubscription? _subscription;

  // ── Tab state ───────────────────────────────────────────
  int categoryIndex = 0;

  final List<String> tabs = [
    "All",
    "Forex",
    "Crypto",
    "Indices",
  ];

  // ── Kraken pair → your symbol name ──────────────────────
  final Map<String, String> _pairMap = {
    "XBT/USD": "BTCUSD",
    "ETH/USD": "ETHUSD",
    "SOL/USD": "SOLUSD",
    "XRP/USD": "XRPUSD",
    "ADA/USD": "ADAUSD",
  };

  // ── Instruments list ────────────────────────────────────
  // This is your display config
  // When your backend is ready → replace this with API call
  List<InstrumentModel> instruments = [

    // ── Crypto ──────────────────────────
    InstrumentModel(
      name:   "BTCUSD",
      type:   "crypto",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   false,
    ),
    InstrumentModel(
      name:   "ETHUSD",
      type:   "crypto",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   false,
    ),
    InstrumentModel(
      name:   "SOLUSD",
      type:   "crypto",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   false,
    ),
    InstrumentModel(
      name:   "XRPUSD",
      type:   "crypto",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   false,
    ),
    InstrumentModel(
      name:   "ADAUSD",
      type:   "crypto",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   false,
    ),

    // ── Forex ────────────────────────────
    // Add when you have a forex WebSocket source
    InstrumentModel(
      name:   "EURUSD",
      type:   "forex",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   true,
    ),
    InstrumentModel(
      name:   "GBPUSD",
      type:   "forex",
      price1: "--",
      price2: "--",
      change: "--",
      isUp:   true,
    ),
  ];

  // ── Filtered list for UI ────────────────────────────────
  List<InstrumentModel> get filteredList {
    if (categoryIndex == 0) return instruments;
    final type = tabs[categoryIndex].toLowerCase();
    return instruments.where((e) => e.type == type).toList();
  }

  // ── Start live prices ───────────────────────────────────
  void startLivePrices() {

    // Only connect for pairs we have in pairMap
    final pairs = _pairMap.keys.toList();
    debugPrint("pairs: $pairs");
    _ws.connect(pairs);

    _subscription = _ws.priceStream.listen(
      _onPriceUpdate,
      onError: (e) => debugPrint("Provider stream error: $e"),
    );

    debugPrint("Live prices started");
  }

  // ── Handle incoming price update ────────────────────────
  void _onPriceUpdate(Map<String, dynamic> data) {
  debugPrint("Data is : $data");
    final krakenPair = data["pair"]   as String;
    final bid        = data["bid"]    as String;
    final ask        = data["ask"]    as String;
    final change     = data["change"] as String;
    final isUp       = data["isUp"]   as bool;
    final high       = data["high"]   as String;
    final low        = data["low"]    as String;
    final spread     = data["spread"] as String;


    debugPrint("krakenPair: $krakenPair bid  $bid  ask $ask  change $change isup $isUp  high $high low $low  spread $spread");

    // Find matching instrument
    final symbol = _pairMap[krakenPair];
    if (symbol == null) return;

    final index = instruments.indexWhere((e) => e.name == symbol);
    if (index == -1) return;

    // ✅ Use copyWith — clean and readable
    instruments[index] = instruments[index].copyWith(
      price1: bid,
      price2: ask,
      change: "${isUp ? '+' : ''}$change%",
      isUp:   isUp,
      high:   high,
      low:    low,
      spread: spread,
    );

    notifyListeners();
  }

  // ── Change category tab ─────────────────────────────────
  void changeCategory(int index) {
    if (categoryIndex == index) return;
    categoryIndex = index;
    notifyListeners();
  }

  // ── Stop live prices ────────────────────────────────────
  void stopLivePrices() {
    _subscription?.cancel();
    _ws.disconnect();
    debugPrint("Live prices stopped");
  }

  // ── Dispose ─────────────────────────────────────────────
  @override
  void dispose() {
    stopLivePrices();
    super.dispose();
  }
}
// features/dashboard/model/instrument_model.dart
// features/dashboard/model/instrument_model.dart

class InstrumentModel {
  final String name;
  final String type;
  final String price1;   // bid
  final String price2;   // ask
  final String change;   // "+1.23%"
  final bool   isUp;
  final String high;
  final String low;
  final String spread;

  const InstrumentModel({
    required this.name,
    required this.type,
    required this.price1,
    required this.price2,
    required this.change,
    required this.isUp,
    this.high   = "--",
    this.low    = "--",
    this.spread = "--",
  });

  // ── Copy with updated values ───────────────────────────
  InstrumentModel copyWith({
    String? name,
    String? type,
    String? price1,
    String? price2,
    String? change,
    bool?   isUp,
    String? high,
    String? low,
    String? spread,
  }) {
    return InstrumentModel(
      name:   name   ?? this.name,
      type:   type   ?? this.type,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      change: change ?? this.change,
      isUp:   isUp   ?? this.isUp,
      high:   high   ?? this.high,
      low:    low    ?? this.low,
      spread: spread ?? this.spread,
    );
  }
}