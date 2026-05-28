import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Login com e-mail e senha
  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Cadastro de novo usuário integrado com a tabela public.users
  Future<AuthResponse> signUp(String email, String password, String name) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    // Nota: Como você usa uma tabela public.users manual (não apenas a do Auth), 
    // se não houver um trigger no banco, precisamos inserir manualmente.
    // Mas geralmente o Supabase usa Triggers para sincronizar auth.users com public.users.
    
    return response;
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Obter perfil do usuário logado da tabela public.users
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('email', user.email as Object)
          .single();
      return data;
    } catch (e) {
      return null;
    }
  }

  // Verificar se é admin baseado na tabela public.users
  Future<bool> isAdmin() async {
    final profile = await getUserProfile();
    if (profile == null) return false;
    // O seu SQL define role como 'cidadao' ou 'admin' (geralmente em minúsculo no SQL)
    return profile['role']?.toString().toLowerCase() == 'admin';
  }
}
