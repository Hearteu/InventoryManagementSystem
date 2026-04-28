import 'package:flutter/material.dart';
import '../theme.dart';

class AddPartScreen extends StatelessWidget {
  const AddPartScreen({super.key});

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
              onPressed: () {},
              child: const Text('SAVE PART', style: TextStyle(fontWeight: FontWeight.bold)),
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
                // Form Header Area
                Text('New Component Profile', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Text(
                  'Enter the specifications, tracking details, and supply chain anchors for the new inventory item. Ensure SKU alignment with standard operating protocols.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                // Form Layout
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
              onPressed: () {},
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
              onPressed: () {},
              icon: const Icon(Icons.save, size: 18),
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
          _buildTextField(context, 'PART NAME', 'e.g. High-Pressure Valve Assembly'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField(context, 'INTERNAL SKU', 'PRC-VAL-0092')),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(context, 'OEM NUMBER', 'Mfg Part #')),
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
          Expanded(child: _buildTextField(context, 'PRIMARY MATERIAL', 'e.g. 316L Stainless')),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(context, 'WEIGHT (KG)', '0.00', isNumber: true)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextField(context, 'DIMENSIONS (LXWXH MM)', '0 x 0 x 0')),
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
          _buildTextField(context, 'INITIAL QUANTITY', '0', icon: Icons.tag, isNumber: true),
          const SizedBox(height: 24),
          _buildTextField(context, 'REORDER THRESHOLD', 'Minimum stock level', icon: Icons.warning_amber_rounded, isNumber: true),
          const SizedBox(height: 24),
          _buildTextField(context, 'EST. UNIT COST (USD)', '0.00', prefixText: '\$', isNumber: true),
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

  Widget _buildTextField(BuildContext context, String label, String hint, {IconData? icon, String? prefixText, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        TextField(
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
        DropdownButtonFormField<String>(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hint: Text(hint),
          items: [
            DropdownMenuItem(value: 'pneumatics', child: Text('Pneumatics & Hydraulics')),
            DropdownMenuItem(value: 'electrical', child: Text('Electrical Components')),
            DropdownMenuItem(value: 'mechanical', child: Text('Mechanical Drives')),
            DropdownMenuItem(value: 'structural', child: Text('Structural Fasteners')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
