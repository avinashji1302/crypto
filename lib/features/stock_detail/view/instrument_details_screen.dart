import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/base_view_model.dart';
import '../viewmodel/details_provider.dart';


class InstrumentDetailScreen extends StatelessWidget {
  const InstrumentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar ───────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.instrument.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              vm.displayPrice,
              style: TextStyle(
                color: vm.instrument.isUp
                    ? Colors.green.shade700
                    : Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  vm.instrument.change,
                  style: TextStyle(
                    color: vm.instrument.isUp
                        ? Colors.green.shade700
                        : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "H:${vm.instrument.high}  L:${vm.instrument.low}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
        
            const Divider(height: 1),
        
            // ── Interval Tabs ───────────────────────────
            _IntervalTabs(
              selected:   vm.selectedInterval,
              onSelected: vm.changeInterval,
            ),
        
            // ── Chart ────────────────────────────────────
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.state == ViewState.error
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Failed to load chart"),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: vm.loadCandles,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
                  : vm.candles.isEmpty
                  ? const Center(child: Text("No chart data"))
                  : Candlesticks(candles: vm.candles),
            ),
        
            // ── Buy / Sell Buttons ───────────────────────
            _BuySellButtons(
              onSell: () => debugPrint("Sell ${vm.instrument.name}"),
              onBuy:  () => debugPrint("Buy ${vm.instrument.name}"),
            ),
        
          ],
        ),
      ),
    );
  }
}


// ── Interval Tabs Widget ─────────────────────────────────
class _IntervalTabs extends StatelessWidget {
  final String selected;
  final void Function(String) onSelected;

  const _IntervalTabs({
    required this.selected,
    required this.onSelected,
  });

  static const intervals = ["1m", "5m", "15m", "1h", "4h", "1D", "1W"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: intervals.length,
        itemBuilder: (context, index) {
          final isSelected = intervals[index] == selected;
          return GestureDetector(
            onTap: () => onSelected(intervals[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                intervals[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// ── Buy / Sell Buttons Widget ────────────────────────────
class _BuySellButtons extends StatelessWidget {
  final VoidCallback onSell;
  final VoidCallback onBuy;

  const _BuySellButtons({
    required this.onSell,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [

          // Sell button
          Expanded(
            child: ElevatedButton(
              onPressed: onSell,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Sell",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Buy button
          Expanded(
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Buy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}