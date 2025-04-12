import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  final VoidCallback onSubmit;

  const Rating({super.key, required this.onSubmit});

  @override
  State<Rating> createState() => _Rating();
}

class _Rating extends State<Rating> {
  int rating = 0;
  final TextEditingController commentController = TextEditingController();

  void setRating(int index) {
    setState(() {
      rating = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF134A7C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Send us your rating!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setRating(index + 1),
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow[600],
                      size: 30,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
               const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Comment',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Write your comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // You can pass the rating and comment data here
                  print("Rating: $rating");
                  print("Comment: ${commentController.text}");
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 30),
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
