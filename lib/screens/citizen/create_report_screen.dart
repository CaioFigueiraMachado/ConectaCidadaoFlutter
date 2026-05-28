import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/services/data_service.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Asfalto';
  String _selectedUrgency = 'Média';
  bool _isLoading = false;
  final _dataService = DataService();

  final List<String> _categories = ['Asfalto', 'Iluminação', 'Saneamento', 'Segurança', 'Limpeza', 'Outros'];
  final List<String> _urgencies = ['Baixa', 'Média', 'Alta'];

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _dataService.createReport(
        title: _titleController.text,
        category: _selectedCategory,
        location: _locationController.text,
        description: _descriptionController.text,
        urgency: _selectedUrgency,
      );
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência enviada com sucesso!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: \$e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar Ocorrência', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Título'),
            TextField(controller: _titleController, decoration: _inputDeco('Ex: Buraco na via')),
            const SizedBox(height: 20),
            _buildLabel('Localização'),
            TextField(controller: _locationController, decoration: _inputDeco('Ex: Rua das Flores, 123')),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Categoria'),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                        decoration: _inputDeco(''),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Urgência'),
                      DropdownButtonFormField<String>(
                        value: _selectedUrgency,
                        items: _urgencies.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (v) => setState(() => _selectedUrgency = v!),
                        decoration: _inputDeco(''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel('Descrição Detalhada'),
            TextField(controller: _descriptionController, maxLines: 4, decoration: _inputDeco('Descreva o que está acontecendo...')),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('ENVIAR OCORRÊNCIA', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)));

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  );
}
