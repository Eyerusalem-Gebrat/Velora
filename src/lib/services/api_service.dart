import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://fakestoreapi.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

// Login token
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.data != null && response.data['token'] != null) {
        return response.data['token'] as String;
      }
      throw Exception('Invalid username or password');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception('Network error, please try again');
      }
      throw Exception('Invalid username or password');
    } catch (e) {
      throw Exception('Invalid username or password');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');
      final List data = response.data as List;
      return data
          .map((json) => Product.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (_) {
      throw Exception('Failed to load products, please try again');
    } catch (_) {
      throw Exception('Failed to load products, please try again');
    }
  }

// Gets the products under that category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final encodedCategory = Uri.encodeComponent(category);
      final response = await _dio.get('/products/category/$encodedCategory');
      final List data = response.data as List;
      return data
          .map((json) => Product.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (_) {
      throw Exception('Failed to load products for this category');
    } catch (_) {
      throw Exception('Failed to load products for this category');
    }
  }

// Gets the categories Electronics, Jewelery,....
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      final List data = response.data as List;
      return data.map((item) => item.toString()).toList();
    } on DioException catch (_) {
      throw Exception('Failed to load categories');
    } catch (_) {
      throw Exception('Failed to load categories');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (_) {
      throw Exception('Failed to load user profile');
    } catch (_) {
      throw Exception('Failed to load user profile');
    }
  }
}
