import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_nest/home/view/home_view.dart';
import 'package:skill_nest/home/view_model/home_view_model.dart';
import 'package:skill_nest/introduction.dart';
import 'package:skill_nest/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Skill Nest',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
