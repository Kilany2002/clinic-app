class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final String experience;
  final String description;
  final String price;




  Doctor(  {
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.experience,
    required this.description, required this.price,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'] ?? 'Unknown',
      specialty: json['specialty'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      experience: json['experience'] ?? 0,
      description: json['description'] ?? '',
      price: (json['price'] ?? 0),
    );
  }
}
