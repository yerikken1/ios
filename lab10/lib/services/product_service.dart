import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Error with a user-friendly message shown on the error screen.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ProductService {
  static const String _url = 'https://fakestoreapi.com/products';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(Uri.parse(_url)).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final decoded = jsonDecode(response.body);
          if (decoded is! List) {
            throw const ApiException('Unexpected response format.');
          }
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(Product.fromJson)
              .toList();
        case 404:
          throw const ApiException('Products not found (404).');
        case 500:
          throw const ApiException('Server error (500). Please try again later.');
        default:
          throw ApiException('Request failed with status ${response.statusCode}.');
      }
    } on TimeoutException {
      throw const ApiException(
          'Connection timed out after 10 seconds.\nCheck your internet connection.');
    } on http.ClientException {
      throw const ApiException(
          'You are offline.\nPlease check your internet connection.');
    } on FormatException {
      throw const ApiException('Failed to read data from the server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      // e.g. SocketException on mobile when Airplane mode is on
      throw const ApiException(
          'No internet connection.\nTurn off Airplane mode and try again.');
    }
  }
}
