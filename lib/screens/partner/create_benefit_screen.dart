import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conecta_cidadao/theme.dart';
import 'package:conecta_cidadao/services/data_service.dart';

class CreateBenefitScreen extends StatefulWidget {
  const CreateBenefitScreen({super.key});

  @override
  State<CreateBenefitScreen> createState() => _CreateBenefitScreenState();
}

class _CreateBenefitScreenState extends State<CreateBenefitScreen> {
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Varejo';
  bool _isLoading = false;
  final _dataService = DataService();

  final List<String> _categories = ['Alimentação', 'Varejo', 'Serviços', 'Saúde', 'Lazer', 'Outros'];

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _pointsController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    final points = int.tryParse(_pointsController.text);
    if (points == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pontuação inválida')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _dataService.createBenefit(
        name: _nameController.text,
        category: _selectedCategory,
        points: points,
        description: _descriptionController.text,
      );
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Benefício criado com sucesso!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Benefício', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Título do Benefício'),
            TextField(controller: _nameController, decoration: _inputDeco('Ex: Café da Manhã Completo')),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Pontuação'),
                      TextField(
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco('100'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel('Descrição Comercial'),
            TextField(controller: _descriptionController, maxLines: 4, decoration: _inputDeco('Descreva os detalhes da oferta...')),
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
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('CRIAR RECOMPENSA', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
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
