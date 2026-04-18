import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? compareAtPrice;
  final List<String> images;
  final String? imageUrl;
  final String categoryId;
  final String categoryName;
  final List<String> tags;
  final Map<String, dynamic> attributes;
  final int stockQuantity;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFeatured;
  final bool isNew;
  final double? discountPercentage;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.compareAtPrice,
    required this.images,
    this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    this.tags = const [],
    this.attributes = const {},
    this.stockQuantity = 0,
    this.isAvailable = true,
    this.rating = 0,
    this.reviewCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.isFeatured = false,
    this.isNew = false,
    this.discountPercentage,
  });

  // Get discounted price if applicable
  double get finalPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  // Check if product is on sale
  bool get isOnSale => discountPercentage != null && discountPercentage! > 0;

  // Get savings amount
  double get savingsAmount => isOnSale ? price - finalPrice : 0;

  // Factory constructor for creating from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: json['compareAtPrice'] != null
          ? (json['compareAtPrice'] as num).toDouble()
          : null,
      images: List<String>.from(json['images'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] as num).toDouble()
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'images': images,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'tags': tags,
      'attributes': attributes,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isFeatured': isFeatured,
      'isNew': isNew,
      'discountPercentage': discountPercentage,
    };
  }

  // Copy with
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? compareAtPrice,
    List<String>? images,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    List<String>? tags,
    Map<String, dynamic>? attributes,
    int? stockQuantity,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    bool? isNew,
    double? discountPercentage,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      images: images ?? this.images,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  // Generate sample products
  static List<Product> getSampleProducts() {
    final categories = [
      ('cat_1', 'Watches'),
      ('cat_2', 'Bags'),
      ('cat_3', 'Shoes'),
      ('cat_4', 'Accessories'),
    ];

    final products = [
      _createSampleProduct(
        name: 'Chronos Elite Timepiece',
        description: 'A masterpiece of horological engineering featuring Swiss automatic movement, sapphire crystal, and genuine leather strap.',
        price: 2499.00,
        category: categories[0],
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
        rating: 4.9,
        reviewCount: 128,
        isFeatured: true,
        isNew: true,
      ),
      _createSampleProduct(
        name: 'Executive Leather Briefcase',
        description: 'Handcrafted from full-grain Italian leather with brass hardware and multiple compartments for the modern professional.',
        price: 1899.00,
        category: categories[1],
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
        rating: 4.8,
        reviewCount: 84,
        isFeatured: true,
      ),
      _createSampleProduct(
        name: 'Royal Oxford Wingtips',
        description: 'Hand-stitched calfskin leather shoes with Goodyear welt construction and cushioned leather insoles.',
        price: 749.00,
        category: categories[2],
        imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
        rating: 4.7,
        reviewCount: 156,
        isNew: true,
      ),
      _createSampleProduct(
        name: 'Heritage Aviator Sunglasses',
        description: 'Classic aviator design with polarized lenses and titanium frames for ultimate comfort and style.',
        price: 449.00,
        category: categories[3],
        imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f',
        rating: 4.9,
        reviewCount: 203,
      ),
      _createSampleProduct(
        name: 'Minimalist Chronograph',
        description: 'Clean, modern design meets precision engineering. Features Japanese quartz movement and stainless steel case.',
        price: 599.00,
        category: categories[0],
        imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314',
        rating: 4.6,
        reviewCount: 92,
        discountPercentage: 15,
      ),
      _createSampleProduct(
        name: 'Designer Tote Bag',
        description: 'Spacious yet elegant tote crafted from premium canvas with leather trim and gold-tone hardware.',
        price: 1299.00,
        category: categories[1],
        imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7',
        rating: 4.8,
        reviewCount: 67,
        isFeatured: true,
      ),
      _createSampleProduct(
        name: 'Premium Leather Loafers',
        description: 'Slip-on sophistication with hand-burnished leather and memory foam cushioning for all-day comfort.',
        price: 549.00,
        category: categories[2],
        imageUrl: 'https://images.unsplash.com/photo-1614252369475-a998c9dfa477',
        rating: 4.7,
        reviewCount: 118,
        isNew: true,
      ),
      _createSampleProduct(
        name: 'Silk Pocket Square Collection',
        description: 'Set of five pure silk pocket squares in coordinating colors. Hand-rolled edges.',
        price: 199.00,
        category: categories[3],
        imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80',
        rating: 4.9,
        reviewCount: 45,
      ),
    ];

    return products;
  }

  static Product _createSampleProduct({
    required String name,
    required String description,
    required double price,
    required (String, String) category,
    required String imageUrl,
    double rating = 0,
    int reviewCount = 0,
    bool isFeatured = false,
    bool isNew = false,
    double? discountPercentage,
  }) {
    const uuid = Uuid();
    return Product(
      id: uuid.v4(),
      name: name,
      description: description,
      price: price,
      images: [imageUrl],
      imageUrl: imageUrl,
      categoryId: category.$1,
      categoryName: category.$2,
      rating: rating,
      reviewCount: reviewCount,
      createdAt: DateTime.now(),
      isFeatured: isFeatured,
      isNew: isNew,
      discountPercentage: discountPercentage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        categoryId,
        isAvailable,
        isFeatured,
        isNew,
      ];
}

class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int productCount;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.productCount = 0,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      productCount: json['productCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'productCount': productCount,
      'isActive': isActive,
    };
  }

  static List<Category> getSampleCategories() {
    return [
      const Category(
        id: 'cat_1',
        name: 'Watches',
        description: 'Luxury timepieces',
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
        productCount: 45,
      ),
      const Category(
        id: 'cat_2',
        name: 'Bags',
        description: 'Premium leather goods',
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
        productCount: 32,
      ),
      const Category(
        id: 'cat_3',
        name: 'Shoes',
        description: 'Handcrafted footwear',
        imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
        productCount: 28,
      ),
      const Category(
        id: 'cat_4',
        name: 'Accessories',
        description: 'Finishing touches',
        imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f',
        productCount: 56,
      ),
      const Category(
        id: 'cat_5',
        name: 'Jewelry',
        description: 'Fine jewelry collection',
        imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338',
        productCount: 24,
      ),
      const Category(
        id: 'cat_6',
        name: 'Home',
        description: 'Luxury home decor',
        imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace',
        productCount: 18,
      ),
    ];
  }

  @override
  List<Object?> get props => [id, name, isActive];
}
