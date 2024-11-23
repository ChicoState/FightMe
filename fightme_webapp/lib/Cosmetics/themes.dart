import 'package:flutter/material.dart';

// If you want to set up every color that you want, you can copy the call of vaporwave.

// Guidelines
// Primary will be things like the top bar.
// Surface is what background is now called.
// brightness: Brightness.light or Brightness.dark.
// The "on____" variables will effect the color of the text (if you truly wanted, they could be different colors).
// Don't know when secondary comes in.

List<ColorScheme> themes = [
  ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
  const ColorScheme.dark(),
  const ColorScheme(brightness: Brightness.light, 
                    primary: Colors.tealAccent, 
                    onPrimary: Colors.black, 
                    secondary: Colors.pinkAccent, 
                    onSecondary: Colors.black, 
                    surface: Colors.deepPurple, 
                    onSurface: Colors.black, 
                    error: Colors.red, 
                    onError: Colors.black
                    ),
  const ColorScheme(brightness: Brightness.dark, 
                    primary: Color(0xFF212121),
                    onPrimary: Color(0xFFB0BEC5),
                    secondary: Color(0xFFB0BEC5),
                    onSecondary: Color(0xFFB0BEC5),
                    surface: Color(0xFF616161),
                    onSurface:Color(0xFFB0BEC5),
                    error: Colors.red,
                    onError: Color(0xFFB0BEC5),
                    ),
];

List<String> themeNames = [
  "Default",
  "Dark",
  "Vaporwave",
  "darkmode",
];