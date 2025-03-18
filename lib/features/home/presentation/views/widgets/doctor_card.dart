import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double rating;
  final int experience;
  final double price;

  const DoctorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.experience,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 318,
      height: 270,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 293,
                height: 122.8125,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            width: 115,
                            height: 124,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 60, color: Colors.grey),
                          )
                        : const Icon(Icons.person,
                            size: 60, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                child: Icon(Icons.favorite_border,
                    color: AppColors.color1, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Dr: $name",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(
            "$experience years experience",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            "\$ $price",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
