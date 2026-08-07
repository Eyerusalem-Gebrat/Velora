/// Converts a raw API category string (e.g. "men's clothing")
/// into a display-friendly title-cased string (e.g. "Men's Clothing").
/// Returns the empty string unchanged.
String formatCategory(String category) {
  if (category.isEmpty) return category;
  return category.split(' ').map((word) {
    if (word.isEmpty) return word;
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }).join(' ');
}

/// Formats a double price value as a USD string with 2 decimal places.
/// e.g. 9.99 → "\$9.99"
String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';
