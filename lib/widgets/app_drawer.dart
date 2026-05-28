import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/screens/citizen/citizen_dashboard.dart';
import 'package:conecta_cidadao/screens/citizen/benefits_store_screen.dart';
import 'package:conecta_cidadao/screens/map_screen.dart';

class AppDrawer extends StatelessWidget {
  final String? role;
  const AppDrawer({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.darkNavy),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=user'),
            ),
            accountName: Text(user?.userMetadata?['full_name'] ?? 'Usuário', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            accountEmail: Text(user?.email ?? '', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('MENU PRINCIPAL'),
                _buildMenuItem(context, Icons.dashboard_outlined, 'Visão Geral', () => Navigator.pop(context)),
                _buildMenuItem(context, Icons.map_outlined, 'Mapa Operacional', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
                }),
                
                const Divider(height: 32),
                _buildSectionHeader('ÁREA DO CIDADÃO'),
                _buildMenuItem(context, Icons.person_outline, 'Painel do Cidadão', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CitizenDashboard()));
                }),
                _buildMenuItem(context, Icons.list_alt_outlined, 'Minhas Ocorrências', () {}),
                _buildMenuItem(context, Icons.stars_outlined, 'Meus Pontos', () {}),
                _buildMenuItem(context, Icons.card_giftcard_outlined, 'Benefícios', () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const BenefitsStoreScreen()));
                }),
              ],
            ),
          ),
          const Divider(),
          _buildMenuItem(context, Icons.logout, 'Sair', () async {
            await Supabase.instance.client.auth.signOut();
          }, color: Colors.redAccent),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.textDark, size: 20),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: color ?? AppTheme.textDark)),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
