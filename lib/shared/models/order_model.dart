import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  readyForPickup,
  pickedUp,
  onTheWay,
  delivered,
  cancelled
}

class OrderModel {
  final String id;
  final String customerId;
  final String restaurantId;
  final String? courierId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final GeoPoint deliveryLocation;
  final String deliveryAddress;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? estimatedDeliveryTime;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.courierId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.deliveryLocation,
    required this.deliveryAddress,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedDeliveryTime,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      customerId: map['customerId'] as String,
      restaurantId: map['restaurantId'] as String,
      courierId: map['courierId'] as String?,
      items: List<OrderItem>.from(
        (map['items'] as List<dynamic>).map(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      subtotal: map['subtotal'] as double,
      deliveryFee: map['deliveryFee'] as double,
      total: map['total'] as double,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${map['status']}',
      ),
      deliveryLocation: map['deliveryLocation'] as GeoPoint,
      deliveryAddress: map['deliveryAddress'] as String,
      note: map['note'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      estimatedDeliveryTime: map['estimatedDeliveryTime'] != null
          ? (map['estimatedDeliveryTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'courierId': courierId,
      'items': items.map((x) => x.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.toString().split('.').last,
      'deliveryLocation': deliveryLocation,
      'deliveryAddress': deliveryAddress,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'estimatedDeliveryTime': estimatedDeliveryTime != null
          ? Timestamp.fromDate(estimatedDeliveryTime!)
          : null,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? restaurantId,
    String? courierId,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    OrderStatus? status,
    GeoPoint? deliveryLocation,
    String? deliveryAddress,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? estimatedDeliveryTime,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      restaurantId: restaurantId ?? this.restaurantId,
      courierId: courierId ?? this.courierId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final String? note;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
    this.note,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      total: map['total'] as double,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': total,
      'note': note,
    };
  }
} 