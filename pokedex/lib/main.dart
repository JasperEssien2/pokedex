import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,

        primarySwatch: Colors.blue,
        //TODO: Extract hardcoded colors
        scaffoldBackgroundColor: const Color(0xffE8E8E8),
        textTheme: GoogleFonts.notoSansAdlamTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
