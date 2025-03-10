import 'package:clinicc/features/doctor/logic/doctor_profile_controller.dart';
import 'package:flutter/material.dart';
import '../widgets/menu_item.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key});

  @override
  _DoctorProfileViewState createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  final DoctorProfileController _controller = DoctorProfileController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
    });
    await _controller.fetchUserData();
    setState(() {
    });
  }

  Future<void> _editImage() async {
    setState(() {
    });
    try {
      await _controller.editImage();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update image: $e')),
      );
    } finally {
      setState(() {
      });
    }
  }

  Future<void> _deleteImage() async {
    setState(() {
    });
    try {
      await _controller.deleteImage();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    } finally {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _controller.imageUrl != null
                      ? NetworkImage(_controller.imageUrl!)
                      : const AssetImage('assets/images/sara 1.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editImage();
                      } else if (value == 'delete') {
                        _deleteImage();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Image'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Image'),
                      ),
                    ],
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _controller.name,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _controller.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 150),
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(Icons.privacy_tip, 'Privacy'),
                  buildMenuItem(Icons.history, 'Purchase History'),
                  buildMenuItem(Icons.help, 'Help & Support'),
                  buildMenuItem(Icons.settings, 'Settings'),
                  buildMenuItem(Icons.logout, 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}