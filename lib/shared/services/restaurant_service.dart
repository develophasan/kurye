import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Yeni restoran oluştur
  Future<RestaurantModel> createRestaurant(RestaurantModel restaurant) async {
    final docRef = _firestore.collection('restaurants').doc();
    final newRestaurant = restaurant.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(newRestaurant.toMap());
    return newRestaurant;
  }

  // Restoran bilgilerini güncelle
  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    await _firestore
        .collection('restaurants')
        .doc(restaurant.id)
        .update(restaurant.toMap());
  }

  // Restoran durumunu güncelle (açık/kapalı)
  Future<void> updateRestaurantStatus(String restaurantId, bool isOpen) async {
    await _firestore.collection('restaurants').doc(restaurantId).update({
      'isOpen': isOpen,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Menü öğesi ekle
  Future<void> addMenuItem(String restaurantId, MenuItem item) async {
    await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(item.id)
        .set(item.toMap());
  }

  // Menü öğesi güncelle
  Future<void> updateMenuItem(
    String restaurantId,
    MenuItem item,
  ) async {
    await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(item.id)
        .update(item.toMap());
  }

  // Menü öğesi sil
  Future<void> deleteMenuItem(String restaurantId, String itemId) async {
    await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(itemId)
        .delete();
  }

  // Tüm restoranları getir
  Stream<List<RestaurantModel>> getAllRestaurants() {
    return _firestore
        .collection('restaurants')
        .where('isOpen', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RestaurantModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Kategoriye göre restoranları getir
  Stream<List<RestaurantModel>> getRestaurantsByCategory(String category) {
    return _firestore
        .collection('restaurants')
        .where('categories', arrayContains: category)
        .where('isOpen', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RestaurantModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Restoran detayını getir
  Future<RestaurantModel> getRestaurantDetails(String restaurantId) async {
    final doc = await _firestore.collection('restaurants').doc(restaurantId).get();
    if (!doc.exists) {
      throw Exception('Restoran bulunamadı');
    }
    return RestaurantModel.fromMap(doc.data()!);
  }

  // Restoranın menüsünü getir
  Stream<List<MenuItem>> getRestaurantMenu(String restaurantId) {
    return _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MenuItem.fromMap(doc.data())).toList();
    });
  }

  // Yakındaki restoranları getir
  Future<List<RestaurantModel>> getNearbyRestaurants(
    GeoPoint userLocation,
    double radiusInKm,
  ) async {
    // Firestore'da GeoPoint ile mesafe hesaplama
    // Bu örnek için basit bir yaklaşım kullanıyoruz
    // Gerçek uygulamada GeoFlutterFire gibi bir kütüphane kullanılabilir
    
    final snapshot = await _firestore
        .collection('restaurants')
        .where('isOpen', isEqualTo: true)
        .get();

    final restaurants = snapshot.docs
        .map((doc) => RestaurantModel.fromMap(doc.data()))
        .where((restaurant) {
      final distance = _calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        restaurant.location.latitude,
        restaurant.location.longitude,
      );
      return distance <= radiusInKm;
    }).toList();

    // Mesafeye göre sırala
    restaurants.sort((a, b) {
      final distanceA = _calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        a.location.latitude,
        a.location.longitude,
      );
      final distanceB = _calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        b.location.latitude,
        b.location.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return restaurants;
  }

  // İki nokta arasındaki mesafeyi hesapla (Haversine formülü)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Dünya yarıçapı (km)
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180);
  }
} 