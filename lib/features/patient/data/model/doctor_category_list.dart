class Doctor {
  final String id;
  final String userId;
  final String name;
  final String categoryId;
  final double rating;
  final String imageUrl;
  final String experience;
  final String description;
  final String price;
  final bool isPaid;
  final String? fcmToken; 
  final List<Map<String, dynamic>> destinations;

  Doctor({
    required this.id,
    required this.userId,
    required this.name,
    required this.categoryId,
    required this.rating,
    required this.imageUrl,
    required this.experience,
    required this.description,
    required this.price,
    required this.isPaid,
    this.fcmToken, 
    required this.destinations,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '', // Safe conversion
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Doctor',
      categoryId: json['category_id']?.toString() ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['image_url']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      isPaid: json['isPaid'] ?? false,
      fcmToken: json['users']?['fcm_token']?.toString(), // Safe access
      destinations: List<Map<String, dynamic>>.from(json['destinations'] ?? []),
    );
  }

  List<String> get locations {
    return destinations
        .map<String>((d) => d['location']?.toString() ?? '')
        .where((loc) => loc.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category_id': categoryId,
      'rating': rating,
      'image_url': imageUrl,
      'experience': experience,
      'description': description,
      'price': price,
      'isPaid': isPaid,
      'fcm_token': fcmToken,
      'destinations': destinations,
    };
  }
}
