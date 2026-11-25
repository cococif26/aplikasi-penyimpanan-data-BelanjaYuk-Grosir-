import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/product.dart';
import '../service/api_service.dart';
import '../widget/error_view.dart';
import '../widget/loading_view.dart';
import '../widget/product_card.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSearchTap;
  const HomePage({super.key, required this.onSearchTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  final Map<String, String> _categories = const {
    'Semua': '',
    'Groceries': 'groceries',
    'Dapur': 'kitchen-accessories',
    'Kecantikan': 'beauty',
  };
  String _selected = 'Semua';
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Product>> _load() =>
      _api.getProducts(category: _categories[_selected]!);

  void _select(String key) {
    setState(() {
      _selected = key;
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Text(
                  'BelanjaYuk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onSearchTap,
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.search, color: AppColors.dark),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
                children: [
                  TextSpan(text: 'Belanja Barang\nGrosir '),
                  TextSpan(
                    text: 'Terbaik',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _categories.keys.map((k) {
                final active = k == _selected;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => _select(k),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? AppColors.dark : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        k,
                        style: TextStyle(
                          color: active ? Colors.white : AppColors.dark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Text(
              'Koleksi Terbaik',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const LoadingView();
                }
                if (snap.hasError) {
                  return ErrorView(
                    message: snap.error.toString(),
                    onRetry: () => setState(() => _future = _load()),
                  );
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('Barang tidak ditemukan'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => ProductCard(product: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
