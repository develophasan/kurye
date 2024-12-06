import 'package:flutter/material.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  
  // Giriş yap
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      _currentUser = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Kayıt ol
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      _currentUser = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Şifre sıfırlama e-postası gönder
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Çıkış yap
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.signOut();
      _currentUser = null;
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Yükleniyor durumunu güncelle
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  // Hata mesajını temizle
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Hata mesajını ayarla
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }
} 