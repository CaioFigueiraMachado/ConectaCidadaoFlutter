import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/widgets/app_header.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['TODOS', 'PENDENTES', 'EM EXECUÇÃO', 'RESOLVIDOS'];
  final List<Color> _filterColors = [
    AppTheme.primaryBlue,
    const Color(0xFFEF4444),
    const Color(0xFFF59E0B),
    const Color(0xFF10B981),
  ];

  final List<Map<String, dynamic>> _occurrences = [
    {
      'title': 'Protocolo em',
      'name': 'Caio',
      'location': 'Isso Lanpred',
      'status': 'RESOLVIDO',
      'color': const Color(0xFF10B981),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Title + Search
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitoramento',
                          style: GoogleFonts.inter(
                            color: AppTheme.textDark,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'OCORRÊNCIAS EM TEMPO REAL',
                          style: GoogleFonts.inter(
                            color: AppTheme.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Pesquisar problema ou local...',
                              hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 13),
                              prefixIcon: const Icon(Icons.search, color: AppTheme.textLight, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FILTRAR POR STATUS',
                          style: GoogleFonts.inter(
                            color: AppTheme.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_filters.length, (i) {
                            final selected = _filterIndex == i;
                            return GestureDetector(
                              onTap: () => setState(() => _filterIndex = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selected ? _filterColors[i] : AppTheme.lightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selected ? _filterColors[i] : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _filters[i],
                                      style: GoogleFonts.inter(
                                        color: selected ? Colors.white : AppTheme.textLight,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: selected ? Colors.white.withOpacity(0.25) : AppTheme.textLight.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Text(
                                          i == 0 ? '1' : '0',
                                          style: GoogleFonts.inter(
                                            color: selected ? Colors.white : AppTheme.textLight,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                // Map placeholder
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Map grid
                          CustomPaint(
                            painter: _MapGridPainter(),
                            child: Container(color: const Color(0xFFE8F0E8)),
                          ),
                          // Roads
                          CustomPaint(painter: _RoadsPainter()),
                          // Zoom controls
                          Positioned(
                            right: 12,
                            bottom: 50,
                            child: Column(
                              children: [
                                const _MapButton(icon: Icons.add),
                                const SizedBox(height: 4),
                                const _MapButton(icon: Icons.remove),
                              ],
                            ),
                          ),
                          // Legend
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  _LegendItem(color: Color(0xFFEF4444), label: 'PENDENTE'),
                                  _LegendItem(color: Color(0xFFF59E0B), label: 'EM EXECUÇÃO'),
                                  _LegendItem(color: Color(0xFF10B981), label: 'RESOLVIDO'),
                                ],
                              ),
                            ),
                          ),
                          // Marker
                          Positioned(
                            left: 160,
                            top: 100,
                            child: Column(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Results
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RESULTADOS (1)',
                          style: GoogleFonts.inter(
                            color: AppTheme.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._occurrences.map((o) => _OccurrenceCard(data: o)),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Icon(icon, size: 18, color: AppTheme.textDark),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textLight, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _OccurrenceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _OccurrenceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] as String,
                  style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  data['name'] as String,
                  style: GoogleFonts.inter(color: AppTheme.textDark, fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textLight),
                    const SizedBox(width: 2),
                    Text(data['location'] as String, style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: data['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0DDD0)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    // Horizontal roads
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), paint);
    // Vertical roads
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.6, size.height), paint);
    // City names
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final style = const TextStyle(color: Color(0xFF667777), fontSize: 8);
    final cities = [
      const MapEntry('Campinas', Offset(0.5, 0.12)),
      const MapEntry('São Paulo', Offset(0.55, 0.65)),
      const MapEntry('Sorocaba', Offset(0.1, 0.68)),
      const MapEntry('Santos', Offset(0.45, 0.85)),
    ];
    for (final city in cities) {
      textPainter.text = TextSpan(text: city.key, style: style);
      textPainter.layout();
      textPainter.paint(canvas, Offset(city.value.dx * size.width, city.value.dy * size.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
