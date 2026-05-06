import 'package:app/app.dart';
import 'package:app/features/auth/login/viewmodel/login_model.dart';
import 'package:app/features/auth/register/viewmodel/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app/app_viewmodel.dart';
import 'core/network/connectivity_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppViewModel()..initializeApp(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
      ],
      child: const App(),
    );
  }
}

