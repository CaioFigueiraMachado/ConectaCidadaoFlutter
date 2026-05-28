import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/screens/admin/user_management_screen.dart';
import 'package:conecta_cidadao/widgets/app_drawer.dart';
import 'package:conecta_cidadao/screens/map_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _supabase = Supabase.instance.client;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  int _totalReports = 0;
  int _activeUsers = 0;
  int _activePartners = 0;
  double _successRate = 100.0;
  List<Map<String, dynamic>> _recentHistory = [];
  Map<String, int> _categories = {};

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      try {
        final reports = await _supabase.from('reports').select('id, categoria, status');
        _totalReports = reports.length;
        
        Map<String, int> cats = {};
        for (var r in reports) {
          String cat = r['categoria'] ?? 'Outros';
          cats[cat] = (cats[cat] ?? 0) + 1;
        }
        _categories = cats;

        final history = await _supabase
            .from('reports')
            .select('titulo, data, created_at')
            .order('created_at', ascending: false)
            .limit(5);
        _recentHistory = List<Map<String, dynamic>>.from(history);
      } catch (e) {
        debugPrint('Erro em reports: $e');
      }

      try {
        final users = await _supabase.from('users').select('id').eq('status', 'Ativo');
        _activeUsers = users.length;

        final partners = await _supabase.from('users').select('id').eq('role', 'parceiro');
        _activePartners = partners.length;
      } catch (e) {
        debugPrint('Erro em users: $e');
      }

    } catch (e) {
      debugPrint('Erro geral stats: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(role: 'admin'),
      body: RefreshIndicator(
        onRefresh: _fetchStats,
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Painel do Admin',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                    _buildDemandsSection(),
                    const SizedBox(height: 24),
                    _buildHistorySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = _supabase.auth.currentUser;
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppTheme.textDark),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        children: [
          Image.asset('assets/logo.png', width: 24, height: 24, errorBuilder: (c,e,s) => const Icon(Icons.location_city, color: AppTheme.primaryBlue, size: 24)),
          const SizedBox(width: 8),
          Text(
            'Conecta Cidadão',
            style: GoogleFonts.inter(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen())),
          icon: const Icon(Icons.people_outline, color: AppTheme.textDark)
        ),
        IconButton(onPressed: _fetchStats, icon: const Icon(Icons.refresh, color: AppTheme.textDark)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: AppTheme.textDark)),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _StatCard(title: 'TOTAL OCORRÊNCIAS', value: _totalReports.toString(), icon: Icons.description_outlined, color: Colors.blue),
        _StatCard(title: 'USUÁRIOS ATIVOS', value: _activeUsers.toString(), icon: Icons.people_outline, color: Colors.green),
        _StatCard(title: 'PARCERIAS ATIVAS', value: _activePartners.toString(), icon: Icons.handshake_outlined, color: Colors.purple),
        _StatCard(title: 'TAXA DE SUCESSO', value: '${_successRate.toInt()}%', icon: Icons.check_circle_outline, color: Colors.orange),
      ],
    );
  }

  Widget _buildDemandsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Demandas por Categoria', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen())),
                child: Text('VER NO MAPA GLOBAL', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_categories.isEmpty) 
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Nenhuma demanda registrada')))
          else
            ..._categories.entries.map((e) {
              double pct = _totalReports > 0 ? e.value / _totalReports : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildDemandBar(e.key.toUpperCase(), pct),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDemandBar(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('${(percentage * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          color: AppTheme.darkNavy,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Histórico Recente', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          if (_recentHistory.isEmpty)
            const Text('Sem atividades recentes', style: TextStyle(color: Colors.white70))
          else
            ..._recentHistory.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildHistoryItem(item['titulo'] ?? 'Sem título', item['data'] ?? item['created_at']?.substring(0,10) ?? ''),
            )),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String date) {
    return Row(
      children: [
        Container(width: 4, height: 24, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(date, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[600])),
              Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            ],
          ),
        ],
      ),
    );
  }
}
