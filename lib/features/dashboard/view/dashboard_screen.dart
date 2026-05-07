import 'package:app/features/dashboard/view/trading_screen.dart';
import 'package:app/features/dashboard/view/widgets/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final screens = [
    Center(child: Text("Space")),
    Center(child: TradingScreen()),
    Center(child: Text("Orders")),
    Center(child: Text("Dashboard")),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("clicked....3");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),

        drawer:   Drawer(
        backgroundColor: Colors.red,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Ttem 1"),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                title: Text("Item 2"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      )
    );
  }
}
