import 'package:dio/dio.dart';
import '../model/candel_model.dart';


class DetailRepository {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.kraken.com",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // interval → 1=1m, 5=5m, 15=15m, 60=1h, 240=4h, 1440=1D, 10080=1W
  Future<List<CandleModel>> getCandles({
    required String pair,     // "XBTUSD"
    required int interval,    // 60
  }) async {

    final response = await _dio.get(
      "/0/public/OHLC",
      queryParameters: {
        "pair":     pair,
        "interval": interval,
      },
    );

    // Kraken response structure:
    // {
    //   "error": [],
    //   "result": {
    //     "XXBTZUSD": [[time, open, high, low, close, vwap, vol, count],...],
    //     "last": 1234567890
    //   }
    // }

    final result = response.data["result"] as Map<String, dynamic>;

    // Remove "last" key — it's not candle data
    result.remove("last");

    // First remaining key is the candle data
    final candleList = result.values.first as List<dynamic>;

    return candleList
        .map((raw) => CandleModel.fromKraken(raw as List<dynamic>))
        .toList();
  }
}