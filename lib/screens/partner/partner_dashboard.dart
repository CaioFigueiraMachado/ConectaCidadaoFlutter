import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/screens/partner/create_benefit_screen.dart';
import 'package:conecta_cidadao/widgets/app_drawer.dart';

class PartnerDashboard extends StatefulWidget {
  const PartnerDashboard({super.key});

  @override
  State<PartnerDashboard> createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  final _supabase = Supabase.instance.client;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  String _partnerName = '';
  int _activeRewards = 0;
  int _redeemedVouchers = 0;
  int _distributedPoints = 0;
  int _estimatedReach = 0;
  List<Map<String, dynamic>> _recentRedemptions = [];

  @override
  void initState() {
    super.initState();
    _fetchPartnerData();
  }

  Future<void> _fetchPartnerData() async {
    setState(() => _isLoading = true);
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final profile = await _supabase
          .from('users')
          .select()
          .eq('email', user.email as Object)
          .single();
      
      _partnerName = profile['name'] ?? 'Parceiro';
      final partnerId = profile['id'];

      final benefits = await _supabase
          .from('benefits')
          .select('id')
          .eq('partner_id', partnerId);
      _activeRewards = benefits.length;

      final redemptions = await _supabase
          .from('redeemed')
          .select('*, benefits!inner(partner_id)')
          .eq('benefits.partner_id', partnerId);
      
      _redeemedVouchers = redemptions.length;
      _distributedPoints = 0;
      for (var r in redemptions) {
        _distributedPoints += (r['pontos'] as int? ?? 0);
      }

      final recent = await _supabase
          .from('redeemed')
          .select('*, benefits!inner(partner_id)')
          .eq('benefits.partner_id', partnerId)
          .order('created_at', ascending: false)
          .limit(5);
      
      _recentRedemptions = List<Map<String, dynamic>>.from(recent);

    } catch (e) {
      debugPrint('Erro no Dashboard do Parceiro: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(role: 'parceiro'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textDark),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 24, height: 24, errorBuilder: (c,e,s) => const Icon(Icons.location_city, color: AppTheme.primaryBlue, size: 24)),
            const SizedBox(width: 8),
            Text('Painel da Empresa', style: GoogleFonts.inter(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(onPressed: _fetchPartnerData, icon: const Icon(Icons.refresh, color: AppTheme.textDark)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: AppTheme.textDark)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=partner')),
          ),
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
                _buildWelcomeBanner(),
                const SizedBox(height: 24),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildRecentRedemptions()),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: Column(
                      children: [
                        _buildPerformanceCard(),
                        const SizedBox(height: 24),
                        _buildDailyTip(),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateBenefitScreen()),
          );
          if (result == true) _fetchPartnerData();
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text('DASHBOARD DE PARCEIRO', 
                  style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
              Text('Olá, ${_partnerName.toUpperCase()}!', 
                style: GoogleFonts.inter(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Sua parceria está gerando impacto positivo na cidade.', 
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Row(
              children: [
                _buildBannerStatus('STATUS', 'ATIVO', Colors.green),
                const SizedBox(width: 16),
                _buildBannerStatus('IMPACTO', 'ALTO', Colors.blue),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBannerStatus(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(color: color, fontSize: 14, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _StatCard(label: 'RECOMPENSAS ATIVAS', value: _activeRewards.toString(), icon: Icons.workspace_premium_outlined, color: Colors.blue, sub: 'Itens no catálogo'),
        _StatCard(label: 'VOUCHERS RESGATADOS', value: _redeemedVouchers.toString(), icon: Icons.confirmation_number_outlined, color: Colors.green, sub: 'Total de conversões'),
        _StatCard(label: 'PONTOS DISTRIBUÍDOS', value: _distributedPoints.toString(), icon: Icons.star_outline, color: Colors.orange, sub: 'Economia gerada'),
        _StatCard(label: 'ALCANCE ESTIMADO', value: _estimatedReach.toString(), icon: Icons.group_outlined, color: Colors.purple, sub: 'Visualizações de marca'),
      ],
    );
  }

  Widget _buildRecentRedemptions() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppTheme.primaryBlue, size: 20),
                  const SizedBox(width: 12),
                  Text('Resgates Recentes', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Text('VER TODOS', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          if (_recentRedemptions.isEmpty)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.confirmation_number_outlined, color: Color(0xFFE2E8F0), size: 48),
                  const SizedBox(height: 16),
                  Text('NENHUM RESGATE AINDA.', style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w900)),
                ],
              ),
            )
          else
            ..._recentRedemptions.map((r) => _buildRedemptionItem(r)),
        ],
      ),
    );
  }

  Widget _buildRedemptionItem(Map<String, dynamic> r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const CircleAvatar(radius: 16, backgroundColor: AppTheme.lightGrey, child: Icon(Icons.person, size: 16, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['nome'] ?? 'Cidadão', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(r['code'] ?? '', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text(r['data'] ?? '', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              Text('Desempenho', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressRow('Popularidade', 0.85, Colors.purple),
          const SizedBox(height: 16),
          _buildProgressRow('Retenção', 0.62, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double val, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
            Text('${(val * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: val, backgroundColor: const Color(0xFFF1F5F9), color: color, minHeight: 6, borderRadius: BorderRadius.circular(3)),
      ],
    );
  }

  Widget _buildDailyTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Dica do Dia', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
            ],
          ),
          const SizedBox(height: 12),
          Text('Oferecer recompensas de menor valor (como cafés ou descontos rápidos) aumenta em 3x o fluxo de novos clientes.', 
            style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey[100]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFF64748B), letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 12),
                  const SizedBox(width: 4),
                  Text(sub, style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
