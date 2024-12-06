import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/restaurant_model.dart';
import '../../../shared/services/restaurant_service.dart';

class HomeViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService = RestaurantService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  List<RestaurantModel> _restaurants = [];
  List<RestaurantModel> get restaurants => _restaurants;
  
  List<RestaurantModel> _nearbyRestaurants = [];
  List<RestaurantModel> get nearbyRestaurants => _nearbyRestaurants;
  
  List<String> _categories = [];
  List<String> get categories => _categories;
  
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;
  
  // Tüm restoranları getir
  Future<void> getAllRestaurants() async {
    try {
      _setLoading(true);
      _clearError();
      
      _restaurantService.getAllRestaurants().listen(
        (restaurants) {
          _restaurants = restaurants;
          _updateCategories();
          notifyListeners();
        },
        onError: (error) {
          _setError(error.toString());
        },
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Kategoriye göre restoranları getir
  Future<void> getRestaurantsByCategory(String category) async {
    try {
      _setLoading(true);
      _clearError();
      
      _selectedCategory = category;
      
      _restaurantService.getRestaurantsByCategory(category).listen(
        (restaurants) {
          _restaurants = restaurants;
          notifyListeners();
        },
        onError: (error) {
          _setError(error.toString());
        },
      );
    } finally {
      _setLoading(false);
    }
  }
  
  // Yakındaki restoranları getir
  Future<void> getNearbyRestaurants(double latitude, double longitude) async {
    try {
      _setLoading(true);
      _clearError();
      
      _nearbyRestaurants = await _restaurantService.getNearbyRestaurants(
        GeoPoint(latitude, longitude),
        5, // 5 km yarıçapında
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  // Kategorileri güncelle
  void _updateCategories() {
    final Set<String> uniqueCategories = {};
    
    for (final restaurant in _restaurants) {
      uniqueCategories.addAll(restaurant.categories);
    }
    
    _categories = uniqueCategories.toList()..sort();
    notifyListeners();
  }
  
  // Kategori seçimini temizle
  void clearCategoryFilter() {
    _selectedCategory = null;
    getAllRestaurants();
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