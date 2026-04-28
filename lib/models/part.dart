class Part {
  final String id;
  final String sku;
  final String name;
  final String? category;
  final int quantityOnHand;
  final int reorderPoint;

  Part({
    required this.id,
    required this.sku,
    required this.name,
    this.category,
    required this.quantityOnHand,
    required this.reorderPoint,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      quantityOnHand: json['quantity_on_hand'] as int? ?? 0,
      reorderPoint: json['reorder_point'] as int? ?? 0,
    );
  }

  // Helper method to determine the status text and colors
  String get status {
    if (quantityOnHand == 0) return 'Out of Stock';
    if (quantityOnHand <= reorderPoint) return 'Low Stock';
    return 'In Stock';
  }
}
