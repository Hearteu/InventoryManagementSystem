import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/part.dart';

class StockMovementScreen extends StatefulWidget {
  const StockMovementScreen({super.key});

  @override
  State<StockMovementScreen> createState() => _StockMovementScreenState();
}

class _StockMovementScreenState extends State<StockMovementScreen> {
  final ApiService _apiService = ApiService();
  String _transactionType = 'inbound';
  
  String? _selectedPartId;
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  
  bool _isLoadingParts = true;
  bool _isSaving = false;
  List<Part> _parts = [];

  @override
  void initState() {
    super.initState();
    _fetchParts();
  }
  
  Future<void> _fetchParts() async {
    try {
      final parts = await _apiService.getParts();
      if (mounted) {
        setState(() {
          _parts = parts;
          _isLoadingParts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingParts = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load parts: \$e')));
      }
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _recordMovement() async {
    if (_selectedPartId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a part')));
      return;
    }
    
    final qty = int.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid positive quantity')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _apiService.addStockMovement(
        _selectedPartId!,
        _transactionType,
        qty,
        _notesCtrl.text.isEmpty ? '' : _notesCtrl.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock movement recorded successfully')));
        _qtyCtrl.clear();
        _notesCtrl.clear();
        setState(() {
          _selectedPartId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Record Stock Movement', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text('Register inbound deliveries or outbound allocations.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRANSACTION TYPE', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeRadio('inbound', 'Inbound', Icons.arrow_downward),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTypeRadio('outbound', 'Outbound', Icons.arrow_upward),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 600;
                        return Column(
                          children: [
                            if (isDesktop)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: _buildPartDropdown()),
                                  const SizedBox(width: 16),
                                  Expanded(flex: 2, child: _buildTextField('QUANTITY', '0', null, isNumber: true, controller: _qtyCtrl)),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildPartDropdown(),
                                  const SizedBox(height: 16),
                                  _buildTextField('QUANTITY', '0', null, isNumber: true, controller: _qtyCtrl),
                                ],
                              ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Select a part to register movement.',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isDesktop) const Expanded(flex: 1, child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildTextField('REASON / NOTE', 'Optional details regarding this movement...', null, maxLines: 3, controller: _notesCtrl),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _qtyCtrl.clear();
                            _notesCtrl.clear();
                            setState(() => _selectedPartId = null);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).colorScheme.outline),
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : _recordMovement,
                          icon: _isSaving 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save, size: 18),
                          label: const Text('Record Movement'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PART SELECTION', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        if (_isLoadingParts)
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: LinearProgressIndicator(),
          )
        else
          InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceBright,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPartId,
                isExpanded: true,
                hint: const Text('Select a part...'),
                items: _parts.map((part) {
                  return DropdownMenuItem(
                    value: part.id,
                    child: Text('\${part.sku} - \${part.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPartId = value;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeRadio(String value, String label, IconData icon) {
    final isSelected = _transactionType == value;
    return GestureDetector(
      onTap: () => setState(() => _transactionType = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.surfaceContainerLow : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant, width: 2),
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                right: 0,
                top: 0,
                child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData? prefixIcon, {bool isNumber = false, int maxLines = 1, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).colorScheme.outline) : null,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceBright,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
