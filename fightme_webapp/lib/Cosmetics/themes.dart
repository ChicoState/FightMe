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
  const ColorScheme(brightness: Brightness.light, primary: Colors.tealAccent, onPrimary: Colors.black, secondary: Colors.pinkAccent, onSecondary: Colors.black, surface: Colors.deepPurple, onSurface: Colors.black, error: Colors.red, onError: Colors.black),
];

List<String> themeNames = [
  "Default",
  "Dark",
  "Vaporwave",
];