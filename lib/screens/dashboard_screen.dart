import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/hover_card.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = ApiService().getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overview', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text('Real-time inventory metrics across all zones.', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (isDesktop)
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: const Text('EXPORT REPORT'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text('RECEIVE STOCK'),
                    ),
                  ],
                ),
            ],
          ),
          if (!isDesktop) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: const Text('EXPORT REPORT'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('RECEIVE STOCK'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          // Metrics Bento Grid
          FutureBuilder<Map<String, dynamic>>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading stats: \${snapshot.error}'));
              }
              
              final stats = snapshot.data ?? {};
              final totalParts = stats['total_parts']?.toString() ?? '0';
              final totalValue = '\$${stats['total_value']?.toStringAsFixed(2) ?? '0.00'}';
              final lowStock = stats['low_stock_alerts']?.toString() ?? '0';
              final pendingMovs = stats['recent_movements']?.toString() ?? '0';

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1024) { crossAxisCount = 4; }
                  else if (constraints.maxWidth > 600) { crossAxisCount = 2; }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.8,
                    children: [
                      _buildMetricCard(
                        context,
                        title: 'TOTAL PARTS',
                        icon: Icons.inventory_2_outlined,
                        value: totalParts,
                        trend: 'Live from database',
                        trendUp: true,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'LOW STOCK ALERTS',
                        icon: Icons.warning_amber_rounded,
                        value: lowStock,
                        trend: 'Requires attention',
                        isAlert: int.tryParse(lowStock) != null && int.parse(lowStock) > 0,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'TOTAL VALUE',
                        icon: Icons.payments_outlined,
                        value: totalValue,
                        trend: 'Live valuation',
                        trendUp: true,
                      ),
                      _buildMetricCard(
                        context,
                        title: 'RECENT MOVEMENTS',
                        icon: Icons.sync_alt,
                        value: pendingMovs,
                        trend: 'Last 24 hours',
                      ),
                    ],
                  );
                },
              );
            }
          ),

          const SizedBox(height: 24),
          // Complex Layout Section
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 1024) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildRecentTransactions(context)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildCriticalShortages(context)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildRecentTransactions(context),
                  const SizedBox(height: 24),
                  _buildCriticalShortages(context),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, {required String title, required IconData icon, required String value, required String trend, bool trendUp = false, bool isAlert = false, List<double>? spots}) {
    return HoverCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAlert ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.2) : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isAlert ? Theme.of(context).colorScheme.error.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outlineVariant),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isAlert ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              Icon(icon, color: isAlert ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outline, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: isAlert ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (trendUp) const Icon(Icons.trending_up, size: 14, color: Colors.green),
                  if (trendUp) const SizedBox(width: 4),
                  Text(
                    trend,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isAlert ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (spots != null && spots.isNotEmpty)
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: spots.length.toDouble() - 1,
                  minY: spots.reduce((a, b) => a < b ? a : b) * 0.9,
                  maxY: spots.reduce((a, b) => a > b ? a : b) * 1.1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(spots.length, (index) => FlSpot(index.toDouble(), spots[index])),
                      isCurved: true,
                      color: isAlert ? Theme.of(context).colorScheme.error : (trendUp ? Colors.green : Theme.of(context).colorScheme.primary),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (isAlert ? Theme.of(context).colorScheme.error : (trendUp ? Colors.green : Theme.of(context).colorScheme.primary)).withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('View All', style: Theme.of(context).textTheme.bodySmall),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
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
                DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('PART NAME', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TYPE', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                _buildTableRow(context, 'TX-8921', 'Hydraulic Pump Assy', 'Inbound', '+12', 'Completed', Colors.green),
                _buildTableRow(context, 'TX-8920', 'Bearing Unit 45mm', 'Outbound', '-50', 'Pending', Colors.orange),
                _buildTableRow(context, 'TX-8919', 'Control Board V2', 'Adjustment', '-2', 'Flagged', Theme.of(context).colorScheme.error),
                _buildTableRow(context, 'TX-8918', 'O-Ring Kit Standard', 'Inbound', '+200', 'Completed', Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildTableRow(BuildContext context, String id, String name, String type, String qty, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(type, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        DataCell(Text(qty)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border(left: BorderSide(color: statusColor, width: 2)),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalShortages(BuildContext context) {
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
          Text('Critical Shortages', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildShortageItem(context, 'Sensor Array X-12', 'Qty: 2 (Min: 15)', true),
          const SizedBox(height: 12),
          _buildShortageItem(context, 'Drive Belt 88mm', 'Qty: 8 (Min: 10)', false),
        ],
      ),
    );
  }

  Widget _buildShortageItem(BuildContext context, String name, String qty, bool isCritical) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCritical ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3) : Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isCritical ? Theme.of(context).colorScheme.error.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              Text(qty, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_shopping_cart, size: 18, color: isCritical ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant),
            style: IconButton.styleFrom(
              backgroundColor: isCritical ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }
}
