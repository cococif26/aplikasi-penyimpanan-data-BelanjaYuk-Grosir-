import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../service/api_service.dart';
import '../widget/error_view.dart';
import '../widget/loading_view.dart';
import '../widget/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _api = ApiService();
  final _ctrl = TextEditingController();
  Timer? _debounce;

  List<Product> _results = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;
  int _requestId = 0; // mencegah hasil lama menimpa hasil baru

  Future<void> _search(String value) async {
    _debounce?.cancel();
    final q = value.trim();

    if (q.isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
        _searched = false;
        _error = null;
      });
      return;
    }

    final id = ++_requestId;
    setState(() {
      _loading = true;
      _searched = true;
      _error = null;
    });

    try {
      final data = await _api.search(q);
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(value));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) {
      return ErrorView(message: _error!, onRetry: () => _search(_ctrl.text));
    }
    if (!_searched) {
      return const Center(child: Text('Ketik nama barang untuk mencari'));
    }
    if (_results.isEmpty) {
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
      itemCount: _results.length,
      itemBuilder: (_, i) => ProductCard(product: _results[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'Cari Barang',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _ctrl,
              onChanged: _onChanged,
              onSubmitted: _search, // tombol Enter
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari mascara, apel, minyak...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () => _search(_ctrl.text), // tombol cari
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
