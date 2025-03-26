import 'package:clinicc/core/utils/colors.dart';

import 'package:clinicc/pages/role_screen.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, String>> pages = [
    {
      'image': 'assets/images/doctor.jpg',
      'title': 'Choose your doctor',
      'description':
          'Application provides you with a lot of experienced doctors...',
    },
    {
      'image': 'assets/images/calendar.jpg',
      'title': 'Choose date and time',
      'description':
          'The application can help you choose the appropriate date and time for you and the selected doctor.',
    },
    {
      'image': 'assets/images/chat.jpg',
      'title': 'Communicate with your doctor',
      'description':
          'Once you access the profile of doctor you selected, you can communicate with him and send any message.',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: pages[index]['image']!,
                title: pages[index]['title']!,
                description: pages[index]['description']!,
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: _currentPage != pages.length - 1
                ? TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoleSelectionScreen()),
                      );
                    },
                    child: Text('Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                : SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pages[_currentPage]['title']!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    pages[_currentPage]['description']!,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Spacer(),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: pages.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.blue,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == pages.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoleSelectionScreen()),
                            );
                          } else {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        },
                        child: Row(
                          children: [
                            Text(_currentPage == pages.length - 1
                                ? 'Start'
                                : 'Next'),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
