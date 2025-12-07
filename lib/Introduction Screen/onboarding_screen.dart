
// Onboarding Screen

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trackit/pages/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardigScreenState();
}

class _OnBoardigScreenState extends State<OnboardingScreen> {
  // controller to keep track of which page we're on
  final PageController _controller = PageController();

  // keep track of if we are do the last page
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [IntroPage1(), IntroPage2(), IntroPage3()],
          ),
          // dot indication
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text(
                    "skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // dot indication
                SmoothPageIndicator(controller: _controller, count: 3),
                // next or done
                onLastPage
                    ? GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seenOnboarding', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                        );
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Page 1
class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/page1.jpg', height: 250),
            const SizedBox(height: 30),
            const Text(
              "Welcome to Daily Do",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Start building your best self one habit at a time.",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Page 2
class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/page2.jpg', height: 250),
            const SizedBox(height: 30),
            const Text(
              "Stay Organized and Motivated",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Daily plans and mindful reminders to keep you on track.",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Page 3
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/page3.jpg', height: 250),
            const SizedBox(height: 30),
            const Text(
              "Let's Get Started",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Begin your journey to better habits today.",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
