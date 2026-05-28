import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/widgets/app_header.dart';
import 'package:conecta_cidadao/screens/login_screen.dart';

class ProblemsScreen extends StatelessWidget {
  const ProblemsScreen({super.key});

  static const List<Map<String, dynamic>> _problems = [
    {
      'icon': Icons.traffic_outlined,
      'title': 'Vias e Conservação',
      'desc': 'Buracos, rachaduras e asfalto danificado que comprometem a segurança de todos.',
      'color': Color(0xFF3B82F6),
    },
    {
      'icon': Icons.lightbulb_outline,
      'title': 'Iluminação Pública',
      'desc': 'Postes apagados aumentam o risco de criminalidade noturna.',
      'color': Color(0xFFEAB308),
    },
    {
      'icon': Icons.delete_outline,
      'title': 'Acúmulo de Lixo',
      'desc': 'Descarte irregular que gera riscos de doença e poluição visual.',
      'color': Color(0xFF10B981),
    },
    {
      'icon': Icons.accessible_forward_outlined,
      'title': 'Acessibilidade',
      'desc': 'Falta de rampas e calçadas irregulares que isolam cidadãos com mobilidade reduzida.',
      'color': Color(0xFF8B5CF6),
    },
    {
      'icon': Icons.water_damage_outlined,
      'title': 'Drenagem',
      'desc': 'Sistemas de bueiros ineficientes que resultam em alagamentos.',
      'color': Color(0xFF06B6D4),
    },
    {
      'icon': Icons.warning_amber_outlined,
      'title': 'Riscos Geológicos',
      'desc': 'Áreas de encostas sem monitoramento preventivo.',
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: AppHeader()),
          // HERO SECTION
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1628), Color(0xFF0F172A)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A Problemática',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    'Urbana.',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Entenda por que a falta de conexão entre cidadãos e governo é o maior obstáculo para o desenvolvimento das nossas cidades.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SILENCE SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionBadge(
                    icon: Icons.search,
                    label: 'O GRANDE DESAFIO',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cidades que sofrem\nem silêncio.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'O maior problema urbano não é o buraco na sua rua ou a lâmpada queimada, mas a ineficiência de canais para quem tem o poder de resolvê-los.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sem um canal direto, as demandas perdem-se em burocracias, gerando frustração no cidadão e ineficiência no uso de recursos públicos.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // STATISTICS HIGHLIGHT ROW
                  Row(
                    children: const [
                      _StatHighlightCard(
                        value: '72%',
                        label: 'das ocorrências não são registradas.',
                      ),
                      SizedBox(width: 16),
                      _StatHighlightCard(
                        value: '154h',
                        label: 'tempo médio de espera.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // DAILY OBSTACLES (6 Grid items)
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.lightGrey,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Obstáculos Diários',
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mapeamos os principais gargalos urbanos que afetam a qualidade de vida nos bairros brasileiros.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textLight,
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: _problems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = _problems[index];
                      return _ProblemCard(
                        icon: item['icon'] as IconData,
                        title: item['title'] as String,
                        desc: item['desc'] as String,
                        color: item['color'] as Color,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // CTA SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        const TextSpan(text: 'Quer fazer parte da \n', style: TextStyle(color: AppTheme.textDark)),
                        TextSpan(
                          text: 'mudança?',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.primaryBlue.withOpacity(0.3),
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'COMECE AGORA',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textDark,
                        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'VER PROBLEMAS',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.primaryBlue,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatHighlightCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatHighlightCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _ProblemCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              desc,
              style: GoogleFonts.inter(
                color: AppTheme.textLight,
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
