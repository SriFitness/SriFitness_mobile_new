class Product {
  final String brand;
  final String category;
  final String description;
  final String dimensions;
  final int discount;
  final List<String> images;
  final String manufacturer;
  final String name;
  final String pitch;
  final double price;
  final String productId;
  final int quantity;
  final String thumbnail;
  final String weight;

  Product({
    required this.brand,
    required this.category,
    required this.description,
    required this.dimensions,
    required this.discount,
    required this.images,
    required this.manufacturer,
    required this.name,
    required this.pitch,
    required this.price,
    required this.productId,
    required this.quantity,
    required this.thumbnail,
    required this.weight,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      brand: data['brand'],
      category: data['category'],
      description: data['description'],
      dimensions: data['dimensions'],
      discount: data['discount'],
      images: List<String>.from(data['images']),
      manufacturer: data['manufacturer'],
      name: data['name'],
      pitch: data['pitch'],
      price: (data['price'] as num).toDouble(), // Convert to double
      productId: data['productId'],
      quantity: data['quantity'],
      thumbnail: data['thumbnail'],
      weight: data['weight'],
    );
  }

  double get discountedPrice {
    return price - (price * discount / 100);
  }
}