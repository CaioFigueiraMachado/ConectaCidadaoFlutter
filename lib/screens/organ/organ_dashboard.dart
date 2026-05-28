import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/services/data_service.dart';
import 'package:conecta_cidadao/widgets/app_drawer.dart';

class OrganDashboard extends StatefulWidget {
  const OrganDashboard({super.key});

  @override
  State<OrganDashboard> createState() => _OrganDashboardState();
}

class _OrganDashboardState extends State<OrganDashboard> {
  final _supabase = Supabase.instance.client;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _dataService = DataService();
  bool _isLoading = true;
  int _totalReports = 0;
  int _pendingReports = 0;
  int _inProgressReports = 0;
  double _efficiency = 50.0;
  List<Map<String, dynamic>> _demands = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final reports = await _supabase.from('reports').select();
      _totalReports = reports.length;
      _pendingReports = reports.where((r) => r['status'] == 'Pendente').length;
      _inProgressReports = reports.where((r) => r['status'] == 'Em Execução').length;
      
      final resolved = reports.where((r) => r['status'] == 'Resolvido').length;
      _efficiency = _totalReports > 0 ? (resolved / _totalReports) * 100 : 0;

      final recent = await _supabase
          .from('reports')
          .select()
          .order('created_at', ascending: false)
          .limit(5);
      
      _demands = List<Map<String, dynamic>>.from(recent);
    } catch (e) {
      debugPrint('Erro no Dashboard do Órgão: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(role: 'orgao'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textDark),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Painel Operacional', style: GoogleFonts.inter(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh, color: AppTheme.textDark)),
          const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=organ')),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmergencyStatus(),
                const SizedBox(height: 24),
                _buildTopStats(),
                const SizedBox(height: 24),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildOperationalFlux(),
              ],
            ),
          ),
    );
  }

  Widget _buildEmergencyStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STATUS DE EMERGÊNCIA', style: GoogleFonts.inter(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Todas as áreas operando sob normalidade', 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryBlue, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FEEDBACK DA POPULAÇÃO', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
              Row(
                children: [
                  const Text('4.8', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('/5.0', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 8),
                  const SizedBox(width: 4),
                  Text('NÍVEL EXCELENTE', style: GoogleFonts.inter(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _StatCard(label: 'DEMANDAS TOTAIS', value: _totalReports.toString(), icon: Icons.bar_chart, color: Colors.blue),
        _StatCard(label: 'PENDENTES AGORA', value: _pendingReports.toString(), icon: Icons.error_outline, color: Colors.orange),
        _StatCard(label: 'EM EXECUÇÃO', value: _inProgressReports.toString(), icon: Icons.access_time, color: Colors.purple),
        _StatCard(label: 'EFICIÊNCIA URBANÍSTICA', value: '${_efficiency.toInt()}%', icon: Icons.trending_up, color: Colors.green),
      ],
    );
  }

  Widget _buildOperationalFlux() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fluxo Operacional de Demandas', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('MONITORAMENTO EM TEMPO REAL DAS VIAS URBANAS', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('GERENCIAR FILA ↗', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 24),
          ..._demands.map((d) => _buildDemandItem(d)).toList(),
        ],
      ),
    );
  }

  Widget _buildDemandItem(Map<String, dynamic> d) {
    final urgency = d['urgencia'] ?? 'MÉDIA';
    final urgencyColor = urgency.toUpperCase() == 'ALTA' ? Colors.red : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () => _showStatusDialog(d),
        child: Row(
          children: [
            Text('#${d['id']}', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(d['titulo'] ?? 'Sem título', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                  const SizedBox(width: 4),
                  Expanded(child: Text(d['local'] ?? 'Não inf.', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: urgencyColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(urgency.toUpperCase(), style: GoogleFonts.inter(color: urgencyColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Text(d['data'] ?? '', style: GoogleFonts.inter(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(Map<String, dynamic> d) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atualizar Status - #${d['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Em Execução'),
              leading: const Icon(Icons.access_time, color: Colors.purple),
              onTap: () => _updateStatus(d['id'], 'Em Execução'),
            ),
            ListTile(
              title: const Text('Resolvido'),
              leading: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () => _updateStatus(d['id'], 'Resolvido'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(int id, String status) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);
    try {
      await _dataService.updateReportStatus(id, status);
      _fetchData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      setState(() => _isLoading = false);
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
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
              Text(label, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            ],
          )
        ],
      ),
    );
  }
}
