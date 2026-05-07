import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockDetailsScreen extends StatelessWidget {
   StockDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CandlestickChart(
        CandlestickChartData(
          // read about it in the CandlestickChartData section
        ),
        duration: Duration(milliseconds: 150), // Optional
        curve: Curves.linear, // Optional
      ),
    );
  }
}
