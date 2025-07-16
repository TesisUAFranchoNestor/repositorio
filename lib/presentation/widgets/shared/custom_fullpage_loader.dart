import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/material.dart';

class CustomFullPageLoader extends StatelessWidget {
  final bool isDarkMode;

  const CustomFullPageLoader({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return EasyLoader(
      image: const AssetImage(
        'assets/logo.png',
      ),
      iconColor: isDarkMode ? Colors.white : Colors.black,
      backgroundColor: Colors.black.withOpacity(0.3),
    );
  }
}
