import 'package:candlesticks/candlesticks.dart';

class CandleModel {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  // Kraken sends:
  // [1620000000, "50000", "51000", "49000", "50500", "50200", "1.5", 10]
  //   └─ time     └─ open  └─ high  └─ low   └─ close  └─ vwap  └─vol

  factory CandleModel.fromKraken(List<dynamic> raw) {
    return CandleModel(
      time:   DateTime.fromMillisecondsSinceEpoch((raw[0] as int) * 1000),
      open:   double.parse(raw[1].toString()),
      high:   double.parse(raw[2].toString()),
      low:    double.parse(raw[3].toString()),
      close:  double.parse(raw[4].toString()),
      volume: double.parse(raw[6].toString()),
    );
  }

  // Convert to candlesticks package format
  Candle toCandle() {
    return Candle(
      date:   time,
      open:   open,
      high:   high,
      low:    low,
      close:  close,
      volume: volume,
    );
  }
}