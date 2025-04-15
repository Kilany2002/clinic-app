import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/generated/l10n.dart';
import 'package:clinicc/pages/custom_lang_dropdown.dart';
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
      'image': 'assets/images/1.png',
      'title': 'chooseDateTime',
      'description': 'dateTimeDescription',
    },
    {
      'image': 'assets/images/2.png',
      'title': 'chooseDoctor',
      'description': 'doctorDescription',
    },
    {
      'image': 'assets/images/Untitled design.png',
      'title': 'communicateWithDoctor',
      'description': 'chatDescription',
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
                title: S.of(context).chooseDoctor,
                description: S.of(context).doctorDescription,
              );
            },
          ),
          if (_currentPage != pages.length - 1) ...[
            Positioned(
              top: 50,
              left: 20,
              child: LanguageDropdown(
                onChanged: (lang) {
                  if (lang == 'English') {
                    S.load(Locale('en', 'US'));
                    print("Language set to English");
                  } else if (lang == 'العربية') {
                    S.load(Locale('ar', 'AR'));
                    print("Language set to Arabic");
                  }
                  setState(() {}); // Rebuild the UI to reflect language change
                },
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoleSelectionScreen()),
                  );
                },
                child: Text(
                  S.of(context).skip,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
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
                    S.of(context).chooseDoctor, // Translated title
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).doctorDescription, // Translated description
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
                                ? S
                                    .of(context)
                                    .start // Translated start button text
                                : S
                                    .of(context)
                                    .next), // Translated next button text
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
