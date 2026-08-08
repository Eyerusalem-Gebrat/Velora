import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  User? _currentUser;
  bool _isUserLoading = false;
  String? _userErrorMessage;
  String? _loggedInUsername;

  static const Map<String, int> _usernameToUserId = {
    'mor_2314': 1,
    'johnd': 2,
    'kevinryan': 6,
  };

  AuthProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  User? get currentUser => _currentUser;
  bool get isUserLoading => _isUserLoading;
  String? get userErrorMessage => _userErrorMessage;
  String? get loggedInUsername => _loggedInUsername;

// At start it checks for saved token and user id in storage and fetches the user data if available
  Future<void> checkExistingSession() async {
    final token = await StorageService.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    if (_isLoggedIn) {
      final savedId = await StorageService.getUserId() ?? 1;
      _isUserLoading = true;
      _userErrorMessage = null;
      notifyListeners();
      try {
        _currentUser = await _apiService.getUserById(savedId);
      } catch (e) {
        _userErrorMessage = e.toString().replaceAll('Exception: ', '');
      } finally {
        _isUserLoading = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

// Fetch user data
  Future<void> fetchCurrentUser(String username) async {
    _isUserLoading = true;
    _userErrorMessage = null;
    notifyListeners();

    final id = _usernameToUserId[username] ?? await StorageService.getUserId() ?? 1;
    await StorageService.saveUserId(id);

    try {
      _currentUser = await _apiService.getUserById(id);
    } catch (e) {
      _userErrorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isUserLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _apiService.login(username, password);
      await StorageService.saveToken(token);
      _isLoggedIn = true;
      _errorMessage = null;
      _loggedInUsername = username;
      await fetchCurrentUser(username);
    } catch (e) {
      _isLoggedIn = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await StorageService.clearToken();
    _isLoggedIn = false;
    _errorMessage = null;
    _currentUser = null;
    _loggedInUsername = null;
    _userErrorMessage = null;
    notifyListeners();
  }
}
