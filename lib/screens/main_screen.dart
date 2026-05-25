import 'package:flutter/material.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/screens/home_screen.dart';
import 'package:conecta_cidadao/screens/about_screen.dart';
import 'package:conecta_cidadao/screens/problems_screen.dart';
import 'package:conecta_cidadao/screens/map_screen.dart';
import 'package:conecta_cidadao/screens/benefits_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutScreen(),
    const ProblemsScreen(),
    const MapScreen(),
    const BenefitsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppTheme.darkNavy,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: const Color(0xFF64748B),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home, size: 22),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 22),
              activeIcon: Icon(Icons.people, size: 22),
              label: 'Quem Somos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber_outlined, size: 22),
              activeIcon: Icon(Icons.warning_amber, size: 22),
              label: 'Problemática',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 22),
              activeIcon: Icon(Icons.map, size: 22),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined, size: 22),
              activeIcon: Icon(Icons.card_giftcard, size: 22),
              label: 'Benefícios',
            ),
          ],
        ),
      ),
    );
  }
}
