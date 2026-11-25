import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/product.dart';
import '../pages/detail_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(productId: product.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              product.category,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Expanded(
              child: Center(
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 14,
                top: 4,
                bottom: 4,
                right: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0x55FFFFFF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.dark,
                    child: Icon(
                      Icons.arrow_outward,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
