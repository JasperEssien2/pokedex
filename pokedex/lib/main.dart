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

        primarySwatch: createMaterialColor(const Color(0xff3558CD)),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          labelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.w500),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 4,
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: SliderComponentShape.noThumb,
        ),
        //TODO: Extract hardcoded colors
        scaffoldBackgroundColor: const Color(0xffE8E8E8),
        textTheme: GoogleFonts.notoSansAdlamTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }

  //GOtten from stack overflow
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
