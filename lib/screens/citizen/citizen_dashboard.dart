import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/screens/citizen/create_report_screen.dart';
import 'package:conecta_cidadao/screens/citizen/benefits_store_screen.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _recentReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final profile = await _supabase
          .from('users')
          .select()
          .eq('email', user.email as Object)
          .single();
      
      final reports = await _supabase
          .from('reports')
          .select()
          .eq('user_id', profile['id'])
          .order('created_at', ascending: false)
          .limit(1);

      if (mounted) {
        setState(() {
          _userData = profile;
          _recentReports = List<Map<String, dynamic>>.from(reports);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar dados do cidadão: \$e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = _userData?['name'] ?? 'Cidadão';
    final points = _userData?['pontos'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: AppTheme.textDark),
        title: Row(
          children: [
            const Icon(Icons.location_city, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            Text('Conecta Cidadão', style: GoogleFonts.inter(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BenefitsStoreScreen()));
          }, icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.textDark)),
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh, color: AppTheme.textDark)),
          IconButton(onPressed: () async => await _supabase.auth.signOut(), icon: const Icon(Icons.logout, color: AppTheme.textDark)),
          CircleAvatar(
            radius: 16, 
            backgroundImage: NetworkImage(_userData?['profilepic'] ?? 'https://i.pravatar.cc/150?u=user')
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Painel do Cidadão', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                TextButton.icon(
                  onPressed: _fetchData,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: Text('ATUALIZAR', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Olá, \$name!',
              style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textDark),
            ),
            Text(
              'Sua voz transforma nossa cidade.\nContinue reportando para melhorar sua região.',
              style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _SmallStatCard(label: 'OCORRÊNCIAS', value: _recentReports.length.toString(), icon: Icons.warning_amber, color: Colors.orange),
                const SizedBox(width: 12),
                const _SmallStatCard(label: 'RESOLVIDAS', value: '0', icon: Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                _SmallStatCard(label: 'PONTOS', value: points.toString(), icon: Icons.stars, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            _buildStatusCard(points),
            const SizedBox(height: 24),
            Text('Meu Histórico Recente', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            if (_recentReports.isEmpty)
              const Text('Nenhuma ocorrência registrada por você.')
            else
              ..._recentReports.map((report) => _buildHistoryItem(report)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateReportScreen()),
          );
          if (result == true) _fetchData();
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusCard(int points) {
    const double meta = 800.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
          opacity: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STATUS ATUAL', style: GoogleFonts.inter(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Guardião Urbano', style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Icon(Icons.star_border, color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$points PTS', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('META: \${meta.toInt()} PTS', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: points / meta,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('+ Reportar e Ganhar Pontos', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> report) {
    final status = report['status'] ?? 'Pendente';
    final isResolved = status == 'Resolvido';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isResolved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), 
              shape: BoxShape.circle
            ),
            child: Icon(
              isResolved ? Icons.check : Icons.access_time, 
              color: isResolved ? Colors.green : Colors.orange, 
              size: 20
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['titulo'] ?? 'Sem título', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                Text(report['local'] ?? 'Local não informado', style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isResolved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(
                  status.toUpperCase(), 
                  style: GoogleFonts.inter(
                    color: isResolved ? Colors.green : Colors.orange, 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              const SizedBox(height: 4),
              Text(report['data'] ?? report['created_at']?.substring(0,10) ?? '', style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SmallStatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(label, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
          ],
        ),
      ),
    );
  }
}
