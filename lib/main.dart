import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/screens/main_screen.dart';
import 'package:conecta_cidadao/screens/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ilmubcdolveaasjhdzwl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlsbXViY2RvbHZlYWFzamhkendsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0MTg3NDksImV4cCI6MjA4ODk5NDc0OX0.QPoM1lfKFLjCIwXwk_m-AOtcF6Ncue83T9VW-8TMPYw',
  );

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
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.data?.session;
        if (session != null) {
          return const MainScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
