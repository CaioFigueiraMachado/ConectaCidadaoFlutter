import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _users = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await _supabase.from('users').select().order('name');
      _users = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Erro ao buscar usuários: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Usuário'),
        content: const Text('Tem certeza que deseja remover este usuário permanentemente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _supabase.from('users').delete().eq('id', id);
      _fetchUsers();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário removido')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
    }
  }

  void _showEditRoleDialog(Map<String, dynamic> user) {
    String currentRole = user['role']?.toString().toLowerCase() ?? 'cidadao';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Cargo: ${user["name"]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['cidadao', 'admin', 'orgao', 'parceiro'].map((role) => RadioListTile<String>(
            title: Text(role.toUpperCase()),
            value: role,
            groupValue: currentRole,
            onChanged: (val) async {
              Navigator.pop(context);
              await _updateRole(user['id'], val!);
            },
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _updateRole(int id, String newRole) async {
    try {
      await _supabase.from('users').update({'role': newRole}).eq('id', id);
      _fetchUsers();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cargo atualizado para $newRole')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((u) {
      final name = u['name']?.toString().toLowerCase() ?? '';
      final email = u['email']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase()) || email.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Gestão de Usuários', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou e-mail...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final role = user['role']?.toString().toUpperCase() ?? 'CIDADAO';
    final points = user['pontos'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user['profilepic'] != null ? NetworkImage(user['profilepic']) : null,
            child: user['profilepic'] == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'] ?? 'Sem nome', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(user['email'] ?? '', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(role, style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('$points PTS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                  ],
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditRoleDialog(user), 
            icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey)
          ),
          IconButton(
            onPressed: () => _deleteUser(user['id']), 
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent)
          ),
        ],
      ),
    );
  }
}
