import 'package:app/features/dashboard/view/widgets/category_tab.dart';
import 'package:app/features/dashboard/viewmodel/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stock_detail/view/instrument_details_screen.dart';
import '../../stock_detail/viewmodel/details_provider.dart';
import 'widgets/instrument_tile.dart';


class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  @override
  void initState() {
    super.initState();
    // Start live prices when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().startLivePrices();
    });
  }

  @override
  void dispose() {
    context.read<DashboardProvider>().stopLivePrices();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

debugPrint("clicked....4");
    return Scaffold(
      backgroundColor: Colors.white,

      body: Consumer<DashboardProvider>(
        builder: (BuildContext context, controller, Widget? child) {
          return SafeArea(

            child: Column(
              children: [

                /// HEADER
                // const TopHeader(),

                /// TABS
                 CategoryTabs(categoryIndex: controller.categoryIndex,),

                /// LIST
                Expanded(
                  child: controller.filteredList.isEmpty
                      ? const Center(
                    child: Text(
                      "No instruments found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      :  ListView.separated(
                    itemCount: controller.filteredList.length,
                    separatorBuilder: (_, __) =>
                    const Divider(height: 1),

                    itemBuilder: (context, index) {

                      final item = controller.filteredList[index];

                      return InstrumentTile(
                        instrument: item,
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => DetailProvider(instrument: item),
                                child: const InstrumentDetailScreen(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}