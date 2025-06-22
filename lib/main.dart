import 'package:flutter/cupertino.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'iOS Task Manager',
      theme: CupertinoThemeData(
        primaryColor: const Color.fromARGB(255, 41, 45, 48),
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        barBackgroundColor: CupertinoColors.systemGrey6,
      ),
      home: LoginScreen(),
    );
  }
}
