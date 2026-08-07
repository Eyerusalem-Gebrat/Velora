import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Product> _allProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedCategory;

  ProductProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.getAllProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> get filteredProducts {
    List<Product> list = List.from(_allProducts);

    if (_selectedCategory != null &&
        _selectedCategory!.isNotEmpty &&
        _selectedCategory != 'All') {
      list = list.where((product) {
        return product.category.toLowerCase() ==
            _selectedCategory!.toLowerCase();
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list.where((product) {
        return product.title
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return list;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
