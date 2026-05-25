import 'package:flutter/material.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/screens/main_screen.dart';

void main() {
  runApp(const ConectaCidadaoApp());
}

class ConectaCidadaoApp extends StatelessWidget {
  const ConectaCidadaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta Cidadão',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
