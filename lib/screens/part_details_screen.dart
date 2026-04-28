import 'package:flutter/material.dart';
import '../theme.dart';

class PartDetailsScreen extends StatelessWidget {
  const PartDetailsScreen({super.key});

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
          'ACME Brake Pad XP2',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.inventory, size: 18),
              label: const Text('Adjust Stock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 1024;
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            _buildCoreOverview(context),
                            const SizedBox(height: 24),
                            _buildSpecsMatrix(context),
                            const SizedBox(height: 24),
                            _buildHistoryLog(context),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildSupplierInfo(context),
                            const SizedBox(height: 24),
                            _buildCompatibleVehicles(context),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildCoreOverview(context),
                      const SizedBox(height: 24),
                      _buildSpecsMatrix(context),
                      const SizedBox(height: 24),
                      _buildHistoryLog(context),
                      const SizedBox(height: 24),
                      _buildSupplierInfo(context),
                      const SizedBox(height: 24),
                      _buildCompatibleVehicles(context),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoreOverview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isWide ? 200 : double.infinity,
                height: isWide ? 200 : 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 48, color: Theme.of(context).colorScheme.outlineVariant),
                ),
              ),
              SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CORE IDENTIFIERS', style: Theme.of(context).textTheme.labelSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryFixed,
                            border: Border(left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text('In Stock (Adequate)', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryFixed)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInfoItem(context, 'INTERNAL SKU', 'PRT-BRK-XP2-001', isBold: true)),
                        Expanded(child: _buildInfoItem(context, 'OEM NUMBER', 'OEM-99482-B')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInfoItemWithIcon(context, 'CATEGORY', 'Braking Systems', Icons.category)),
                        Expanded(child: _buildInfoItemWithIcon(context, 'LOCATION', 'Aisle 4, Bin 12-B', Icons.warehouse)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildLargeMetric(context, 'QUANTITY ON HAND', '342')),
                        Expanded(child: _buildLargeMetric(context, 'REORDER POINT', '150', isMuted: true)),
                        Expanded(child: _buildLargeMetric(context, 'UNIT COST', '\$24.50')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.w500 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildInfoItemWithIcon(BuildContext context, String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeMetric(BuildContext context, String label, String value, {bool isMuted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: isMuted ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildSpecsMatrix(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Row(
              children: [
                const Icon(Icons.straighten, size: 18),
                const SizedBox(width: 8),
                Text('Technical Specifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  children: [
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'MATERIAL', 'Ceramic Composite')),
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'WEIGHT', '1.2 kg / set')),
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'DIMENSIONS', '140 x 55 x 18 mm')),
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'FRICTION COEFFICIENT', '0.42 μ')),
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'OPERATING TEMP MAX', '600°C')),
                    SizedBox(width: constraints.maxWidth / 4 - 16, child: _buildInfoItem(context, 'WEAR SENSOR', 'Included (Electronic)')),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryLog(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 8),
                    Text('Stock Movement History', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Full Log'),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerLow),
              columns: [
                DataColumn(label: Text('DATE')),
                DataColumn(label: Text('ACTION')),
                DataColumn(label: Text('QTY CHANGE'), numeric: true),
                DataColumn(label: Text('BALANCE'), numeric: true),
                DataColumn(label: Text('USER / REF')),
              ],
              rows: [
                _buildHistoryRow(context, 'Oct 24, 2023 14:30', 'Outbound', Icons.arrow_outward, Theme.of(context).colorScheme.errorContainer, Theme.of(context).colorScheme.onErrorContainer, '-12', '342', 'J. Doe (WO-8821)', false),
                _buildHistoryRow(context, 'Oct 22, 2023 09:15', 'Inbound', Icons.arrow_downward, Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.1), Theme.of(context).colorScheme.onTertiaryContainer, '+200', '354', 'System (PO-4490)', true),
                _buildHistoryRow(context, 'Oct 18, 2023 16:45', 'Outbound', Icons.arrow_outward, Theme.of(context).colorScheme.errorContainer, Theme.of(context).colorScheme.onErrorContainer, '-4', '154', 'M. Smith (WO-8790)', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildHistoryRow(BuildContext context, String date, String action, IconData actionIcon, Color actionBg, Color actionText, String qtyChange, String balance, String ref, bool isMuted) {
    return DataRow(
      color: WidgetStateProperty.all(isMuted ? Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.3) : Colors.transparent),
      cells: [
        DataCell(Text(date)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: actionBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(actionIcon, size: 14, color: actionText),
                const SizedBox(width: 4),
                Text(action, style: TextStyle(color: actionText, fontSize: 11)),
              ],
            ),
          ),
        ),
        DataCell(Text(qtyChange)),
        DataCell(Text(balance, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(ref, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }

  Widget _buildSupplierInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping, size: 16),
              const SizedBox(width: 8),
              Text('PRIMARY SUPPLIER', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Center(
                  child: Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Global Auto Parts Ltd.', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Vendor ID: VEN-0042', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 12),
          _buildSupplierRow(context, 'Lead Time:', '3-5 Days', Theme.of(context).colorScheme.onSurface),
          const SizedBox(height: 8),
          _buildSupplierRow(context, 'MOQ:', '50 Units', Theme.of(context).colorScheme.onSurface),
          const SizedBox(height: 8),
          _buildSupplierRow(context, 'Contract Status:', 'Active (Auto-Renew)', Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: const Text('View Supplier Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierRow(BuildContext context, String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor)),
      ],
    );
  }

  Widget _buildCompatibleVehicles(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 16),
                const SizedBox(width: 8),
                Text('COMPATIBLE VEHICLES', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          _buildVehicleRow(context, 'Ford Transit Custom', 'Years: 2018 - Present | Trim: Base, Trend'),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          _buildVehicleRow(context, 'Mercedes-Benz Sprinter', 'Years: 2019 - Present | Trim: 2500, 3500'),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          _buildVehicleRow(context, 'Volkswagen Crafter', 'Years: 2017 - Present | All Trims'),
          Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          Container(
            color: Theme.of(context).colorScheme.surfaceBright,
            child: TextButton(
              onPressed: () {},
              child: const Text('Show All 12 Vehicles'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleRow(BuildContext context, String name, String details) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(details, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
