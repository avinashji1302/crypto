import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.rocket_launch_outlined),
          label: "Space",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Trading",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          label: "Orders",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Dashboard",
        ),
      ],
    );
  }
}