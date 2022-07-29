import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/tela_inicial.dart';

void main() {
  runApp(Fazedor());
}

class Fazedor extends StatelessWidget {
  bool isDark;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
       // status bar color
    ));
    return AdaptiveTheme(
      light: light(),
      dark: dark(),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: InitialScreen(isDark),
      ),
    );
  }

  ThemeData light() {
    isDark = false;
    return ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent[700],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent[700],
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  ThemeData dark() {
    isDark = true;
    return ThemeData(
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal[300],
        textTheme: ButtonTextTheme.primary,
      ),
      brightness: Brightness.dark,
    );
  }
}
