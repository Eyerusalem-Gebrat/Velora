class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;
  final String? badge;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.badge,
  });

  String get imageUrl => image;

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingObj = json['rating'] as Map<String, dynamic>?;

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: (ratingObj?['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (ratingObj?['count'] as num?)?.toInt() ?? 0,
      badge: json['badge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
      if (badge != null) 'badge': badge,
    };
  }
}
