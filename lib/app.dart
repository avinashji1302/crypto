import 'package:app/features/home/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app/app_viewmodel.dart';
import 'features/auth/login/view/login_screen.dart';
import 'features/dashboard/view/dashboard_screen.dart';



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final appVM = context.watch<AppViewModel>();

    switch (appVM.status) {

      case AppStatus.initializing:
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );

      case AppStatus.unauthenticated:
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(), // login screen later
        );

      case AppStatus.authenticated:
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DashboardScreen(), // dashboard later
        );
    }
  }
}