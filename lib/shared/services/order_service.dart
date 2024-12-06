import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Yeni sipariş oluştur
  Future<OrderModel> createOrder(OrderModel order) async {
    final docRef = _firestore.collection('orders').doc();
    final newOrder = order.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(newOrder.toMap());
    return newOrder;
  }

  // Sipariş durumunu güncelle
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Kurye ata
  Future<void> assignCourier(String orderId, String courierId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'courierId': courierId,
      'status': OrderStatus.pickedUp.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Müşterinin siparişlerini getir
  Stream<List<OrderModel>> getCustomerOrders(String customerId) {
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Restoranın siparişlerini getir
  Stream<List<OrderModel>> getRestaurantOrders(String restaurantId) {
    return _firestore
        .collection('orders')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Kuryenin siparişlerini getir
  Stream<List<OrderModel>> getCourierOrders(String courierId) {
    return _firestore
        .collection('orders')
        .where('courierId', isEqualTo: courierId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Bekleyen siparişleri getir
  Stream<List<OrderModel>> getPendingOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: OrderStatus.pending.toString().split('.').last)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Sipariş detayını getir
  Future<OrderModel> getOrderDetails(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw Exception('Sipariş bulunamadı');
    }
    return OrderModel.fromMap(doc.data()!);
  }

  // Sipariş istatistiklerini getir
  Future<Map<String, dynamic>> getOrderStats(
    String userId,
    UserType userType,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = _firestore.collection('orders').where(
      userType == UserType.customer
          ? 'customerId'
          : userType == UserType.restaurant
              ? 'restaurantId'
              : 'courierId',
      isEqualTo: userId,
    );

    final querySnapshot = await query
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThanOrEqualTo: endDate)
        .get();

    final orders = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Toplam sipariş sayısı
    final totalOrders = orders.length;

    // Toplam kazanç
    final totalEarnings = orders.fold<double>(
      0,
      (sum, order) => sum + (order['total'] as double),
    );

    // Ortalama sipariş tutarı
    final averageOrderValue = totalOrders > 0 ? totalEarnings / totalOrders : 0;

    // Durumlara göre sipariş sayıları
    final statusCounts = <String, int>{};
    for (final order in orders) {
      final status = order['status'] as String;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return {
      'totalOrders': totalOrders,
      'totalEarnings': totalEarnings,
      'averageOrderValue': averageOrderValue,
      'statusCounts': statusCounts,
    };
  }
}

enum UserType { customer, restaurant, courier } 