import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const _base = 'https://dummyjson.com';

  Future<dynamic> _get(String path) async {
    final res = await http
        .get(Uri.parse('$_base$path'))
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Server bermasalah (kode ${res.statusCode})');
    }
    return jsonDecode(res.body);
  }

  List<Product> _parseList(dynamic data) =>
      (data['products'] as List).map((e) => Product.fromJson(e)).toList();

  Future<List<Product>> getProducts({String category = ''}) async {
    final path = category.isEmpty
        ? '/products?limit=30'
        : '/products/category/$category';
    return _parseList(await _get(path));
  }

  Future<Product> getDetail(int id) async {
    return Product.fromJson(await _get('/products/$id'));
  }

  Future<List<Product>> search(String query) async {
    return _parseList(await _get('/products/search?q=$query'));
  }
}
