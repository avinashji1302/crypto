import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// core/websocket/ws_client.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsClient {

  // ── Singleton ──────────────────────────────────────────
  static final WsClient _instance = WsClient._internal();
  factory WsClient() => _instance;
  WsClient._internal();

  // ── Private fields ─────────────────────────────────────
  WebSocketChannel?  _channel;
  StreamSubscription? _subscription;
  List<String>       _lastPairs = [];
  bool               _isConnected = false;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  // ── Public stream ───────────────────────────────────────
  Stream<Map<String, dynamic>> get priceStream => _controller.stream;
  bool get isConnected => _isConnected;

  // ── Connect ─────────────────────────────────────────────
  void connect(List<String> pairs) {

    if (_isConnected) {
      debugPrint("WS already connected, disconnecting first...");
      disconnect();
    }

    _lastPairs = pairs;

    const url = "wss://ws.kraken.com";
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _isConnected = true;

    debugPrint("WS Connecting: $url");
    debugPrint("WS Subscribing to: $pairs");

    // Send subscription message
    _channel!.sink.add(jsonEncode({
      "event": "subscribe",
      "pair":  pairs,
      "subscription": {"name": "ticker"},
    }));

    // Listen to messages
    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: _onError,
      onDone:  _onDone,
    );
  }

  // ── Message Handler ─────────────────────────────────────
  void _onMessage(dynamic raw) {
    final data = jsonDecode(raw);

    debugPrint("json data is : $data");

    // Skip all Map events (systemStatus, subscriptionStatus, heartbeat)
    if (data is! List) return;

    // Ticker data = [channelID, tickerData, "ticker", "XBT/USD"]
    if (data.length != 4) return;

    final tickerInfo = data[1];
    final pair       = data[3];

    if (tickerInfo is! Map<String, dynamic>) return;
    if (pair       is! String)               return;

    // Make sure all required keys exist
    if (!tickerInfo.containsKey("b")) return;
    if (!tickerInfo.containsKey("a")) return;
    if (!tickerInfo.containsKey("c")) return;
    if (!tickerInfo.containsKey("o")) return;
    if (!tickerInfo.containsKey("h")) return;
    if (!tickerInfo.containsKey("l")) return;

    try {
      // ── Extract all values ──────────────────────────────
      final bid          = tickerInfo["b"][0] as String;  // best bid price
      final ask          = tickerInfo["a"][0] as String;  // best ask price
      final currentPrice = double.parse(tickerInfo["c"][0] as String);
      final openPrice    = double.parse(tickerInfo["o"][1] as String);
      final high         = double.parse(tickerInfo["h"][1] as String);
      final low          = double.parse(tickerInfo["l"][1] as String);

      // ── Calculate change % ──────────────────────────────
      double changePercent = 0;
      if (openPrice != 0) {
        changePercent = ((currentPrice - openPrice) / openPrice) * 100;
      }

      // ── Calculate spread ────────────────────────────────
      final spreadVal = (double.parse(ask) - double.parse(bid))
          .toStringAsFixed(2);

      // ── Push clean data to stream ───────────────────────
      _controller.add({
        "pair":    pair,
        "price":   currentPrice.toStringAsFixed(2),
        "bid":     double.parse(bid).toStringAsFixed(2),
        "ask":     double.parse(ask).toStringAsFixed(2),
        "change":  changePercent.toStringAsFixed(2),
        "isUp":    changePercent >= 0,
        "high":    high.toStringAsFixed(2),
        "low":     low.toStringAsFixed(2),
        "spread":  spreadVal,
      });

      debugPrint("✅ $pair → "
          "bid:\$${double.parse(bid).toStringAsFixed(2)} "
          "ask:\$${double.parse(ask).toStringAsFixed(2)} "
          "(${changePercent.toStringAsFixed(2)}%)");

    } catch (e) {
      debugPrint("WS Parse Error: $e");
    }
  }

  // ── Error Handler ───────────────────────────────────────
  void _onError(dynamic error) {
    debugPrint("WS Error: $error");
    _isConnected = false;
    _reconnect();
  }

  // ── Done Handler ────────────────────────────────────────
  void _onDone() {
    debugPrint("WS Closed");
    _isConnected = false;
    _reconnect();
  }

  // ── Auto Reconnect ──────────────────────────────────────
  void _reconnect() {
    if (_lastPairs.isEmpty) return;

    debugPrint("WS Reconnecting in 3 seconds...");

    Future.delayed(const Duration(seconds: 3), () {
      if (!_controller.isClosed) {
        connect(_lastPairs);
      }
    });
  }

  // ── Disconnect ──────────────────────────────────────────
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _lastPairs = [];
    debugPrint("WS Disconnected");
  }

  // ── Dispose ─────────────────────────────────────────────
  void dispose() {
    disconnect();
    if (!_controller.isClosed) {
      _controller.close();
    }
    debugPrint("WS Disposed");
  }
}