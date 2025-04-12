class Doctor {
  final String id;
  final String userId;
  final String name;
  final String specialty;
  final String categoryId;
  final double rating;
  final String imageUrl;
  final String experience;
  final String description;
  final String price;
  final List<Map<String, dynamic>> destinations;

  Doctor({
    required this.id,
    required this.userId,
    required this.name,
    required this.specialty,
    required this.categoryId,
    required this.rating,
    required this.imageUrl,
    required this.experience,
    required this.description,
    required this.price,
    required this.destinations,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      specialty: json['specialty'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      experience: json['experience']?.toString() ?? '0',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      destinations: List<Map<String, dynamic>>.from(json['destinations'] ?? []),
    );
  }
  List<String> get locations {
    return destinations
        .map<String>((d) => d['location']?.toString() ?? '')
        .where((loc) => loc.isNotEmpty)
        .toList();
  }

  // Add this method to convert to map for database operations if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'specialty': specialty,
      'category_id': categoryId,
      'rating': rating,
      'image_url': imageUrl,
      'experience': experience,
      'description': description,
      'price': price,
      'destinations': destinations,
    };
  }
}
