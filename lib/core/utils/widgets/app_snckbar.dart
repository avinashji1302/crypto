import 'package:flutter/material.dart';

enum SnackbarType {
  success,
  error,
  info,
  warning,
}

class AppSnackbar {

  static void show(
      BuildContext context, {
        required String message,
        SnackbarType type = SnackbarType.info,
      }) {

    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;

      case SnackbarType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;

      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;

      default:
        backgroundColor = Colors.blue;
        icon = Icons.info;
    }

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}