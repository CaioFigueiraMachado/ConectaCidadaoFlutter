import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/screens/login_screen.dart';
import 'package:conecta_cidadao/widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          // APP BAR
          const SliverToBoxAdapter(child: AppHeader()),
          // HERO SECTION WITH CITY BACKGROUND IMAGE
          SliverToBoxAdapter(
            child: _HeroSection(
              fadeAnim: _fadeAnim,
              slideAnim: _slideAnim,
              onLogin: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ),
          // FEATURES SECTION (Segurança, Recompensas, Transparência)
          const SliverToBoxAdapter(child: _FeaturesSection()),
          // MONITORING SECTION (Sua cidade monitorada 24/7)
          const SliverToBoxAdapter(child: _MonitoringSection()),
          // CTA SECTION (O futuro não espera.)
          SliverToBoxAdapter(
            child: _CtaSection(
              onLogin: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onLogin;

  const _HeroSection({
    required this.fadeAnim,
    required this.slideAnim,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 520,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?q=80&w=2000&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay Gradient para escurecer a imagem e destacar os textos
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F172A).withValues(alpha: 0.65),
                    const Color(0xFF0F172A).withValues(alpha: 0.85),
                    const Color(0xFF0F172A),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: FadeTransition(
                opacity: fadeAnim,
                child: SlideTransition(
                  position: slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Sua cidade,',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Text(
                        'seu legado.',
                        style: GoogleFonts.inter(
                          color: AppTheme.primaryBlue,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'A revolução na gestão urbana começa aqui. Reporte ocorrências, ganhe recompensas e transforme o futuro do seu bairro em tempo real.',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'INICIAR AGORA',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
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
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'VER VÍDEO',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.play_arrow, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _FeatureCard(
            icon: Icons.shield_outlined,
            title: 'Segurança',
            desc: 'Ajude a tornar sua cidade mais segura para todos.',
            color: Color(0xFF3B82F6),
          ),
          SizedBox(width: 8),
          _FeatureCard(
            icon: Icons.card_giftcard_outlined,
            title: 'Recompensas',
            desc: 'Ganhe pontos e benefícios por suas contribuições.',
            color: Color(0xFF10B981),
          ),
          SizedBox(width: 8),
          _FeatureCard(
            icon: Icons.account_balance_outlined,
            title: 'Transparência',
            desc: 'Acompanhe as ações e melhorias na sua região.',
            color: Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textLight,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MonitoringSection extends StatelessWidget {
  const _MonitoringSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3), width: 1.0),
            ),
            child: Text(
              'REAL-TIME MONITORING',
              style: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.25,
                letterSpacing: -0.5,
              ),
              children: [
                const TextSpan(text: 'Sua cidade \n', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'monitorada 24/7.', style: TextStyle(color: AppTheme.primaryBlue)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Acesse o mapa interativo para ver todas as demandas da sua região e a taxa de resolução global. Transparência total na palma da sua mão.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          // High-fidelity Map container with image overlay
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=1200',
                      fit: BoxFit.cover,
                      color: const Color(0xFF0F172A).withValues(alpha: 0.4),
                      colorBlendMode: BlendMode.dstATop,
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GlowPinsPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.darkNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
              ),
              child: Text(
                'IR PARA O MAPA',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  final VoidCallback onLogin;
  const _CtaSection({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                height: 1.25,
              ),
              children: [
                const TextSpan(text: 'O futuro não \n', style: TextStyle(color: AppTheme.textDark)),
                TextSpan(text: 'espera.', style: TextStyle(color: AppTheme.primaryBlue)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Junte-se a milhares de cidadãos que já estão redefinindo o conceito de cidade inteligente no Brasil.',
            style: GoogleFonts.inter(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'CRIAR MINHA CONTA',
                style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: Text(
              'CONHECER O PROJETO',
              style: GoogleFonts.inter(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1.0,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PREMIUM GLOWING PINS MAP PAINTER
class _GlowPinsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppTheme.primaryBlue
      ..style = PaintingStyle.fill;

    final pins = [
      Offset(size.width * 0.35, size.height * 0.45),
      Offset(size.width * 0.52, size.height * 0.35),
      Offset(size.width * 0.42, size.height * 0.65),
      Offset(size.width * 0.68, size.height * 0.50),
    ];

    for (final pin in pins) {
      // Glow rings
      canvas.drawCircle(
        pin,
        14,
        Paint()
          ..color = AppTheme.primaryBlue.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        pin,
        8,
        Paint()
          ..color = AppTheme.primaryBlue.withValues(alpha: 0.35)
          ..style = PaintingStyle.fill,
      );
      // Center solid dot
      canvas.drawCircle(pin, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
