import 'package:flutter/material.dart';

class SnackBarWidget {
  final BuildContext context;
  final String label;
  final Color color;
  const SnackBarWidget({
    required this.context,
    required this.label,
    required this.color,
  });
  void show() {
    final hide = ScaffoldMessenger.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Okay!',
          textColor: Colors.grey,
          onPressed: () {
            hide.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
