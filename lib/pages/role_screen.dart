import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/pages/register_screen.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);
  static String id = 'RoleSelectionScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          color: AppColors.color1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you a Patient or Doctor?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RegisterScreen.id,
                        arguments: 'patient',
                      );
                    },
                    child: const Text('Patient',
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 100),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RegisterScreen.id,
                        arguments: 'doctor',
                      );
                    },
                    child: const Text('Doctor',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}