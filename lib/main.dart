import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzler/home_page.dart';
import 'package:puzzler/image_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImageController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomePage(),
      },
    );
  }
}
