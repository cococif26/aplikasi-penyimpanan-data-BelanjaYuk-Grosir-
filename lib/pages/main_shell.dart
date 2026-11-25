import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'home_page.dart';
import 'search_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  Widget _item(IconData icon, int i) {
    final selected = _index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.dark : AppColors.bg,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: selected ? Colors.white : AppColors.dark),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                HomePage(onSearchTap: () => setState(() => _index = 1)),
                const SearchPage(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0x99FFFFFF),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                _item(Icons.home_rounded, 0),
                const SizedBox(width: 6),
                _item(Icons.search_rounded, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
