import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final GeoPoint location;
  final String phone;
  final String email;
  final String? logo;
  final List<String> images;
  final List<String> categories;
  final bool isOpen;
  final Map<String, WorkingHours> workingHours;
  final double rating;
  final int totalRatings;
  final double minimumOrder;
  final double deliveryFee;
  final int averageDeliveryTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.location,
    required this.phone,
    required this.email,
    this.logo,
    required this.images,
    required this.categories,
    required this.isOpen,
    required this.workingHours,
    required this.rating,
    required this.totalRatings,
    required this.minimumOrder,
    required this.deliveryFee,
    required this.averageDeliveryTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      location: map['location'] as GeoPoint,
      phone: map['phone'] as String,
      email: map['email'] as String,
      logo: map['logo'] as String?,
      images: List<String>.from(map['images'] as List<dynamic>),
      categories: List<String>.from(map['categories'] as List<dynamic>),
      isOpen: map['isOpen'] as bool,
      workingHours: Map<String, WorkingHours>.from(
        (map['workingHours'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            WorkingHours.fromMap(value as Map<String, dynamic>),
          ),
        ),
      ),
      rating: map['rating'] as double,
      totalRatings: map['totalRatings'] as int,
      minimumOrder: map['minimumOrder'] as double,
      deliveryFee: map['deliveryFee'] as double,
      averageDeliveryTime: map['averageDeliveryTime'] as int,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': location,
      'phone': phone,
      'email': email,
      'logo': logo,
      'images': images,
      'categories': categories,
      'isOpen': isOpen,
      'workingHours': workingHours.map((key, value) => MapEntry(key, value.toMap())),
      'rating': rating,
      'totalRatings': totalRatings,
      'minimumOrder': minimumOrder,
      'deliveryFee': deliveryFee,
      'averageDeliveryTime': averageDeliveryTime,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    GeoPoint? location,
    List<String>? categories,
    String? imageUrl,
    double? rating,
    bool? isOpen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      location: location ?? this.location,
      phone: this.phone,
      email: this.email,
      logo: this.logo,
      images: this.images,
      categories: categories ?? this.categories,
      isOpen: isOpen ?? this.isOpen,
      workingHours: this.workingHours,
      rating: rating ?? this.rating,
      totalRatings: this.totalRatings,
      minimumOrder: this.minimumOrder,
      deliveryFee: this.deliveryFee,
      averageDeliveryTime: this.averageDeliveryTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WorkingHours {
  final String open;
  final String close;
  final bool isOpen;

  WorkingHours({
    required this.open,
    required this.close,
    required this.isOpen,
  });

  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      open: map['open'] as String,
      close: map['close'] as String,
      isOpen: map['isOpen'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'close': close,
      'isOpen': isOpen,
    };
  }
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final List<String> categories;
  final bool isAvailable;
  final Map<String, dynamic>? options;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.categories,
    required this.isAvailable,
    this.options,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      image: map['image'] as String?,
      categories: List<String>.from(map['categories'] as List<dynamic>),
      isAvailable: map['isAvailable'] as bool,
      options: map['options'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'categories': categories,
      'isAvailable': isAvailable,
      'options': options,
    };
  }
} 