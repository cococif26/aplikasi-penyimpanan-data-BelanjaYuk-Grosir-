import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/product.dart';
import '../service/api_service.dart';
import '../widget/error_view.dart';
import '../widget/loading_view.dart';

class DetailPage extends StatefulWidget {
  final int productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _api = ApiService();
  late Future<Product> _future;
  int _qty = 1;

  @override
  void initState() {
    super.initState();
    _future = _api.getDetail(widget.productId);
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: Icon(icon, color: AppColors.dark),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(
                    Icons.arrow_back_ios_new,
                    () => Navigator.pop(context),
                  ),
                  const Text(
                    'Detail Barang',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  _circleBtn(Icons.favorite_border, () {}),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Product>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const LoadingView();
                  }
                  if (snap.hasError) {
                    return ErrorView(
                      message: snap.error.toString(),
                      onRetry: () => setState(
                        () => _future = _api.getDetail(widget.productId),
                      ),
                    );
                  }
                  final p = snap.data!;
                  final img = p.images.isNotEmpty
                      ? p.images.first
                      : p.thumbnail;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 260,
                          child: Image.network(
                            img,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported, size: 60),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            children: [
                              Text(
                                p.category,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Jumlah'),
                                      Row(
                                        children: [
                                          _qtyBtn(Icons.remove, () {
                                            if (_qty > 1)
                                              setState(() => _qty--);
                                          }),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              _qty.toString().padLeft(2, '0'),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          _qtyBtn(
                                            Icons.add,
                                            () => setState(() => _qty++),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Harga'),
                                      Text(
                                        '\$${p.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(p.description, textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text(
                                'Stok: ${p.stock}  •  Rating: ${p.rating}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 4,
                            bottom: 4,
                            right: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Tambah ke Keranjang',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$_qty x ${p.title} ditambahkan',
                                        ),
                                      ),
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.dark,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.bg,
      child: Icon(icon, size: 16, color: AppColors.dark),
    ),
  );
}
