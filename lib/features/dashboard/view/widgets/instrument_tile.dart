import 'package:flutter/material.dart';

import '../../viewmodel/dashboard_provider.dart';
// features/dashboard/view/widgets/instrument_tile.dart

class InstrumentTile extends StatelessWidget {
  final InstrumentModel instrument;
  final VoidCallback? onTap;
  const InstrumentTile({super.key, required this.instrument , this.onTap});

  (String, String) _splitPrice(String price) {
    final dot = price.lastIndexOf('.');
    if (dot == -1) return (price, '');
    return (price.substring(0, dot), price.substring(dot));
  }

  @override
  Widget build(BuildContext context) {
    final color = instrument.isUp
        ? Colors.green.shade700
        : Colors.red;

    final (base1, suffix1) = _splitPrice(instrument.price1);
    final (base2, suffix2) = _splitPrice(instrument.price2);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [

            // ── Icon ──────────────────────────────
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.currency_bitcoin, size: 20),
            ),

            const SizedBox(width: 12),

            // ── Name + Change + High/Low ──────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(instrument.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),

                  const SizedBox(height: 3),

                  // Change %
                  Text(instrument.change,
                      style: TextStyle(fontSize: 12, color: color)),

                  const SizedBox(height: 2),

                  // High / Low
                  Text(
                    "H:${instrument.high}  L:${instrument.low}",
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // ── Bid + Ask prices ─────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                // Bid (price1) and Ask (price2) side by side
                Row(
                  children: [
                    _PriceColumn(
                      label: "Bid",
                      base: base1,
                      suffix: suffix1,
                      color: color,
                    ),
                    const SizedBox(width: 16),
                    _PriceColumn(
                      label: "Ask",
                      base: base2,
                      suffix: suffix2,
                      color: color,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Spread
                Text(
                  "S:${instrument.spread}",
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final String base;
  final String suffix;
  final Color color;

  const _PriceColumn({
    required this.label,
    required this.base,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        // Label
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500)),

        // Colored price
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black),
            children: [
              TextSpan(text: base),
              TextSpan(text: suffix,
                  style: TextStyle(color: color)),
            ],
          ),
        ),
      ],
    );
  }
}