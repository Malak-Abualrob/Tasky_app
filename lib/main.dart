import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';

import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // قراءة اسم المستخدم من SharedPreferences
  Future<String?> getUserName() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getString("username");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme:ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF181818),
      ),
      debugShowCheckedModeBanner: false,

      home: FutureBuilder<String?>(
        future: getUserName(),

        builder: (context, snapshot) {
          // لسا بنقرأ البيانات
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF181818),

              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF52C070),
                ),
              ),
            );
          }

          // إذا الاسم موجود
          if (snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return MainScreen();
          }

          // إذا الاسم غير موجود
          return const WelcomeScreen();
        },
      ),
    );
  }
}