import 'package:flutter/material.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_nest/home/view/home_view.dart';
import 'package:skill_nest/introduction.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateAfterDelay();
  }

  Future<void> navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool("isFirst") ?? true;

    if (isFirst) {
      await prefs.setBool("isFirst", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroductionScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/images/study.jpg",
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Skill Nest",
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.secondaryWhite,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            )
          ],
        ),
      ),
    );
  }
}
