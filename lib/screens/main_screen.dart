import 'package:flutter/material.dart';
import 'package:conecta_cidadao/services/auth_service.dart';
import 'package:conecta_cidadao/screens/admin/admin_dashboard.dart';
import 'package:conecta_cidadao/screens/citizen/citizen_dashboard.dart';
import 'package:conecta_cidadao/screens/organ/organ_dashboard.dart';
import 'package:conecta_cidadao/screens/partner/partner_dashboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _authService = AuthService();
  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    try {
      final profile = await _authService.getUserProfile();
      if (mounted) {
        setState(() {
          _role = profile?['role']?.toString().toLowerCase();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_role == 'admin') {
      return const AdminDashboard();
    } else if (_role == 'orgao') {
      return const OrganDashboard();
    } else if (_role == 'parceiro') {
      return const PartnerDashboard();
    } else {
      return const CitizenDashboard();
    }
  }
}
