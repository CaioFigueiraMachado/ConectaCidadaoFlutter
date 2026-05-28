import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conecta_cidadao/services/data_service.dart';

class BenefitsStoreScreen extends StatefulWidget {
  const BenefitsStoreScreen({super.key});

  @override
  State<BenefitsStoreScreen> createState() => _BenefitsStoreScreenState();
}

class _BenefitsStoreScreenState extends State<BenefitsStoreScreen> {
  final _supabase = Supabase.instance.client;
  final _dataService = DataService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _benefits = [];
  int _userPoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      final profile = await _supabase.from('users').select('pontos').eq('email', user!.email as Object).single();
      _userPoints = profile['pontos'] ?? 0;

      final benefits = await _supabase.from('benefits').select();
      _benefits = List<Map<String, dynamic>>.from(benefits);
    } catch (e) {
      debugPrint('Erro ao buscar benefícios: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _redeem(Map<String, dynamic> benefit) async {
    if (_userPoints < (benefit['pontos'] as int)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pontos insuficientes!'), backgroundColor: Colors.red));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Resgate'),
        content: Text('Deseja trocar ${benefit["pontos"]} pontos por ${benefit["nome"]}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('CONFIRMAR')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await _dataService.redeemBenefit(benefit['id']);
      _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resgate realizado com sucesso!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Loja de Benefícios', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('$_userPoints PTS', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75),
            itemCount: _benefits.length,
            itemBuilder: (context, index) {
              final b = _benefits[index];
              return _buildBenefitCard(b);
            },
          ),
    );
  }

  Widget _buildBenefitCard(Map<String, dynamic> b) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                image: b['imagem'] != null ? DecorationImage(image: NetworkImage(b['imagem']), fit: BoxFit.cover) : null,
              ),
              child: b['imagem'] == null ? const Center(child: Icon(Icons.card_giftcard, color: Colors.grey, size: 40)) : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b['empresa'] ?? '', style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                Text(b['nome'] ?? '', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${b["pontos"]} pts', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: AppTheme.textDark)),
                    InkWell(
                      onTap: () => _redeem(b),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
