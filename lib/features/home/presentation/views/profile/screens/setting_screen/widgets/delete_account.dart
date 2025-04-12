import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  final VoidCallback onDeleteConfirmed;

  const DeleteAccount({super.key, required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            onDeleteConfirmed(); // Call callback
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
