import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';

class AddPartScreen extends StatefulWidget {
  const AddPartScreen({super.key});

  @override
  State<AddPartScreen> createState() => _AddPartScreenState();
}

class _AddPartScreenState extends State<AddPartScreen> {
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _oemCtrl = TextEditingController();
  final _materialCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _dimCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _reorderCtrl = TextEditingController();
  final _costCtrl = TextEditingController();

  String? _category;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _oemCtrl.dispose();
    _materialCtrl.dispose();
    _weightCtrl.dispose();
    _dimCtrl.dispose();
    _qtyCtrl.dispose();
    _reorderCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePart() async {
    if (_nameCtrl.text.isEmpty || _skuCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and SKU are required')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ApiService().addPart({
        'name': _nameCtrl.text,
        'sku': _skuCtrl.text,
        'oem_number': _oemCtrl.text,
        'category': _category,
        'material': _materialCtrl.text,
        'weight_kg': double.tryParse(_weightCtrl.text),
        'dimensions': _dimCtrl.text,
        'quantity_on_hand': int.tryParse(_qtyCtrl.text) ?? 0,
        'reorder_point': int.tryParse(_reorderCtrl.text) ?? 0,
        'unit_cost': double.tryParse(_costCtrl.text) ?? 0.0,
      });
      if (mounted) {
        Navigator.pop(context, true); // Return true to signal success
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
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(
          'ADD NEW PART',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton(
              onPressed: _isSaving ? null : _savePart,
              child: _isSaving 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('SAVE PART', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Component Profile', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Text(
                  'Enter the specifications, tracking details, and supply chain anchors for the new inventory item. Ensure SKU alignment with standard operating protocols.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 768;
                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: [
                                _buildBasicInfoCard(context),
                                const SizedBox(height: 24),
                                _buildTechSpecsCard(context),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _buildInventoryControlCard(context),
                                const SizedBox(height: 24),
                                _buildSupplierCard(context),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildBasicInfoCard(context),
                          const SizedBox(height: 24),
                          _buildTechSpecsCard(context),
                          const SizedBox(height: 24),
                          _buildInventoryControlCard(context),
                          const SizedBox(height: 24),
                          _buildSupplierCard(context),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _savePart,
              icon: _isSaving 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save, size: 18),
              label: const Text('Save Part'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Basic Information',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildTextField(context, 'PART NAME', 'e.g. High-Pressure Valve Assembly', controller: _nameCtrl),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField(context, 'INTERNAL SKU', 'PRC-VAL-0092', controller: _skuCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(context, 'OEM NUMBER', 'Mfg Part #', controller: _oemCtrl)),
            ],
          ),
          const SizedBox(height: 24),
          _buildDropdownField(context, 'SYSTEM CATEGORY', 'Select functional category...'),
        ],
      ),
    );
  }

  Widget _buildTechSpecsCard(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Technical Specifications',
      icon: Icons.straighten,
      child: Row(
        children: [
          Expanded(child: _buildTextField(context, 'PRIMARY MATERIAL', 'e.g. 316L Stainless', controller: _materialCtrl)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(context, 'WEIGHT (KG)', '0.00', isNumber: true, controller: _weightCtrl)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(context, 'DIMENSIONS (LXWXH MM)', '0 x 0 x 0', controller: _dimCtrl)),
        ],
      ),
    );
  }

  Widget _buildInventoryControlCard(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Inventory Control',
      icon: Icons.inventory_2_outlined,
      accentColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          _buildTextField(context, 'INITIAL QUANTITY', '0', icon: Icons.tag, isNumber: true, controller: _qtyCtrl),
          const SizedBox(height: 24),
          _buildTextField(context, 'REORDER THRESHOLD', 'Minimum stock level', icon: Icons.warning_amber_rounded, isNumber: true, controller: _reorderCtrl),
          const SizedBox(height: 24),
          _buildTextField(context, 'EST. UNIT COST (USD)', '0.00', prefixText: '\$', isNumber: true, controller: _costCtrl),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Primary Supplier',
      icon: Icons.factory_outlined,
      accentColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(context, 'LINK VENDOR', 'Search approved vendors...', icon: Icons.search),
          const SizedBox(height: 8),
          Text(
            'A primary supplier is required to automate reorder workflows.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required IconData icon, required Widget child, Color? accentColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (accentColor != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: accentColor),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest))),
                  child: Row(
                    children: [
                      Icon(icon, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 8),
                      Text(title, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String hint, {IconData? icon, String? prefixText, bool isNumber = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).colorScheme.outlineVariant, size: 20) : null,
            prefixText: prefixText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
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

  Widget _buildDropdownField(BuildContext context, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
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
              value: _category,
              isExpanded: true,
              hint: Text(hint),
              items: const [
                DropdownMenuItem(value: 'pneumatics', child: Text('Pneumatics & Hydraulics')),
                DropdownMenuItem(value: 'electrical', child: Text('Electrical Components')),
                DropdownMenuItem(value: 'mechanical', child: Text('Mechanical Drives')),
                DropdownMenuItem(value: 'structural', child: Text('Structural Fasteners')),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

