import 'package:supabase_flutter/supabase_flutter.dart';

class DataService {
  final _supabase = Supabase.instance.client;

  // --- REPORTS (Citizens & Organ) ---
  
  Future<void> createReport({
    required String title,
    required String category,
    required String location,
    required String description,
    required String urgency,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'Usuário não autenticado';

    // Get user id from public.users
    final profile = await _supabase.from('users').select('id').eq('email', user.email as Object).single();

    await _supabase.from('reports').insert({
      'titulo': title,
      'categoria': category,
      'local': location,
      'descricao': description,
      'urgencia': urgency,
      'user_id': profile['id'],
      'status': 'Pendente',
      'data': DateTime.now().toString().substring(0, 10),
    });
  }

  Future<void> updateReportStatus(int reportId, String newStatus) async {
    await _supabase.from('reports').update({'status': newStatus}).eq('id', reportId);
    
    // Se foi resolvido, dar pontos ao usuário
    if (newStatus == 'Resolvido') {
      final report = await _supabase.from('reports').select('user_id').eq('id', reportId).single();
      final settings = await _supabase.from('system_settings').select('points_on_resolve').eq('id', 1).single();
      
      final pointsToAdd = settings['points_on_resolve'] as int;
      
      final userData = await _supabase.from('users').select('pontos').eq('id', report['user_id']).single();
      final currentPoints = userData['pontos'] as int? ?? 0;
      
      await _supabase.from('users').update({'pontos': currentPoints + pointsToAdd}).eq('id', report['user_id']);
    }
  }

  // --- BENEFITS (Partners) ---

  Future<void> createBenefit({
    required String name,
    required String category,
    required int points,
    required String description,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'Usuário não autenticado';

    final profile = await _supabase.from('users').select('id, name').eq('email', user.email as Object).single();

    await _supabase.from('benefits').insert({
      'nome': name,
      'categoria': category,
      'pontos': points,
      'descricao': description,
      'empresa': profile['name'],
      'partner_id': profile['id'],
      'code': 'CC-\${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    });
  }

  // --- REDEMPTION (Citizens) ---

  Future<void> redeemBenefit(int benefitId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'Usuário não autenticado';

    final profile = await _supabase.from('users').select('id, pontos').eq('email', user.email as Object).single();
    final benefit = await _supabase.from('benefits').select().eq('id', benefitId).single();

    if ((profile['pontos'] as int) < (benefit['pontos'] as int)) {
      throw 'Pontos insuficientes';
    }

    // 1. Deduzir pontos
    await _supabase.from('users').update({
      'pontos': (profile['pontos'] as int) - (benefit['pontos'] as int)
    }).eq('id', profile['id']);

    // 2. Criar registro de resgate
    await _supabase.from('redeemed').insert({
      'user_id': profile['id'],
      'benefit_id': benefitId,
      'nome': profile['name'] ?? 'Cidadão',
      'empresa': benefit['empresa'],
      'pontos': benefit['pontos'],
      'code': benefit['code'],
      'data': DateTime.now().toString().substring(0, 10),
    });
  }
}
