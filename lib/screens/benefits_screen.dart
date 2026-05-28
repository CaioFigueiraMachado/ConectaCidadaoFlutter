import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/widgets/app_header.dart';

class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Todos', 'Café', 'Mercado', 'Livraria', 'Curso', 'Outros'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: AppHeader(isDark: true)),
          // HERO SECTION (Dark Navy)
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              color: AppTheme.darkNavy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Benefícios e',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    'Recompensas.',
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
                    'Aproveite parcerias e benefícios exclusivos para você e seu negócio crescerem ainda mais.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // PARTNERS SPECIAL SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionBadge(label: 'PARCERIAS ESPECIAIS'),
                  const SizedBox(height: 20),
                  Text(
                    'Parcerias que fortalecem seu negócio.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acesse uma rede de parceiros exclusivos para impulsionar seu crescimento e ganhar mais com cada ação.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textLight,
                      fontSize: 13,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Benefit mini circular icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _CircularShortcut(icon: Icons.store_outlined, label: 'Parcerias'),
                      _CircularShortcut(icon: Icons.percent_outlined, label: 'Descontos'),
                      _CircularShortcut(icon: Icons.star_outline, label: 'Recompensas'),
                      _CircularShortcut(icon: Icons.event_available_outlined, label: 'Eventos'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // TAB BAR FOR CATEGORIES
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.lightGrey,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: AppTheme.textLight,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.5),
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 3,
                tabs: _tabs.map((t) => Tab(text: t.toUpperCase())).toList(),
              ),
            ),
          ),
          // BENEFITS GRID
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
                children: const [
                  _BenefitCard(
                    tag: 'CAFÉ',
                    partnerName: 'Starbucks',
                    title: 'Café Espresso Grátis',
                    points: '80 PTS',
                    image: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=150',
                  ),
                  _BenefitCard(
                    tag: 'MERCADO',
                    partnerName: 'Pão de Açúcar',
                    title: 'R\$ 15 em Desconto',
                    points: '150 PTS',
                    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=150',
                  ),
                  _BenefitCard(
                    tag: 'LIVRARIA',
                    partnerName: 'Livraria Cultura',
                    title: 'Cupom R\$ 20 OFF',
                    points: '200 PTS',
                    image: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=150',
                  ),
                  _BenefitCard(
                    tag: 'CURSO',
                    partnerName: 'Alura',
                    title: 'Curso Online Grátis',
                    points: '300 PTS',
                    image: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=150',
                  ),
                ],
              ),
            ),
          ),
          // CTA SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
              child: Column(
                children: [
                  Text(
                    'Quer ganhar mais pontos?',
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'SAIBA MAIS',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // HIGH-FIDELITY DARK FOOTER
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.darkNavy,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.location_city, color: Colors.white, size: 14),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cidade.Coração',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Conectamos empresas que acreditam no poder da cidade com projetos que transformam vidas.',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 10,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 3,
                        child: const _FooterColumn(
                          title: 'Links Rápidos',
                          items: ['Início', 'Serviços', 'Suporte'],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: const _FooterColumn(
                          title: 'Contato',
                          items: ['contato@\nconectacidadao\n.com.br'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Divider(color: Colors.white10, height: 1.5),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      '© 2026 Conecta Cidadão. Todos os direitos reservados.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final String label;
  const _SectionBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: AppTheme.primaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _CircularShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CircularShortcut({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1), width: 1.0),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppTheme.textDark,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final String tag;
  final String partnerName;
  final String title;
  final String points;
  final String image;

  const _BenefitCard({
    required this.tag,
    required this.partnerName,
    required this.title,
    required this.points,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image with overlay Tag badge
            Expanded(
              flex: 11,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.darkNavy.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Content
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            color: AppTheme.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          partnerName,
                          style: GoogleFonts.inter(
                            color: AppTheme.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'RESGATAR • $points',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
      ],
    );
  }
}
