import 'package:eashion2/provider/theme_provider.dart';
import 'package:eashion2/provider/auth_provider.dart';
import 'package:eashion2/provider/cart_provider.dart';
import 'package:eashion2/provider/navigation_provider.dart';
import 'package:eashion2/provider/product_provider.dart';
import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:eashion2/screen/checkout_screen.dart';
import 'package:eashion2/widgets/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final themeController = SmartThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode, 
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              brightness: Brightness.light,
              primary: Colors.black,
              onPrimary: Colors.white,
              secondary: const Color(0xFFF1F5F9),
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.black,
              secondary: const Color(0xFF1E2632),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          home: Wrapper(),
        );
      },
    );
  }
}