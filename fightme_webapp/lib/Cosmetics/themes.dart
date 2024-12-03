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
  const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.tealAccent,
      onPrimary: Colors.black,
      secondary: Colors.pinkAccent,
      onSecondary: Colors.black,
      surface: Colors.deepPurple,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.black),
  const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 136, 74, 172),
      onPrimary: Color.fromARGB(255, 37, 23, 35),
      secondary: Color.fromARGB(255, 107, 7, 99),
      onSecondary: Color.fromARGB(255, 54, 45, 54),
      surface: Color.fromARGB(255, 44, 44, 44),
      onSurface: Color.fromARGB(255, 204, 204, 204),
      error: Color.fromARGB(255, 255, 104, 93),
      onError: Color.fromARGB(255, 105, 43, 53)),
  const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 228, 94, 32),
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromARGB(255, 24, 143, 190),
      onSecondary: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 255, 255, 255),
      onSurface: Color.fromARGB(255, 41, 41, 41),
      error: Color.fromARGB(255, 168, 0, 0),
      onError: Color.fromARGB(255, 255, 255, 255)),
];

// TODO: Match the element in themes.
List<String> themeNames = [
  "Default",
  "Dark",
  "Vaporwave",
  "midnight",
  "sunrise",
];

// Structure: [element in themes, price]
List<List<int>> buyableThemes = [
  [2, 6000],
  [3, 6000],
  [4, 6000],
];
