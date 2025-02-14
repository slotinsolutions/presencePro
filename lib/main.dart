import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/LoginScreen.dart';
import 'package:testapp/pages/SplashScreen.dart';
import 'package:testapp/pages/selectType.dart';
import 'package:testapp/utils/theme_provider.dart';




void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: themeProvider.themeColor,
          scaffoldBackgroundColor: themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: themeProvider.textColor),
            bodyMedium: TextStyle(color: themeProvider.textColor),
          ),
        ),
      home: Splashscreen(),
    );
  }
}

