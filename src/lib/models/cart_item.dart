import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;
  String color;
  double? originalPrice;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
    this.color = 'Grey',
    this.originalPrice,
  });

  double get subtotal => product.price * quantity;
  double get totalPrice => subtotal;

  String get id => product.id.toString();
  String get title => product.title;
  double get price => product.price;
  String get imageUrl => product.image;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
      if (originalPrice != null) 'originalPrice': originalPrice,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(Map<String, dynamic>.from(json['product'])),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      size: json['size'] as String? ?? 'M',
      color: json['color'] as String? ?? 'Grey',
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );
  }
}
