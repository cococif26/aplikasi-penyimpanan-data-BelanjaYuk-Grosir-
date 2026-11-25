import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'pages/main_shell.dart';

void main() => runApp(const BelanjaYukApp());

class BelanjaYukApp extends StatelessWidget {
  const BelanjaYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BelanjaYuk',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      builder: (context, child) => ColoredBox(
        color: AppColors.bg,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
