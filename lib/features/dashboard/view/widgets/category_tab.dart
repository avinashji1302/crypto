import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/dashboard_provider.dart';

class CategoryTabs extends StatelessWidget {
  final int categoryIndex;
  const CategoryTabs({super.key , required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    debugPrint("clicked....2");


    return Consumer<DashboardProvider>(
      builder: (BuildContext context, controller, Widget? child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.tabs.length,

            itemBuilder: (context, index) {
              debugPrint("clicked....");
              final isSelected = categoryIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    GestureDetector(
                      onTap: (){
                        context.read<DashboardProvider>().changeCategory(index);
                      },
                      child: Text(
                        controller.tabs[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.blue
                              : Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (isSelected)
                      Container(
                        height: 3,
                        width: 50,
                        color: Colors.blue,
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },

    );
  }
}