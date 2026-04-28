import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_part_screen.dart';
import 'part_details_screen.dart';
import '../models/part.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Part>> _partsFuture;

  @override
  void initState() {
    super.initState();
    _partsFuture = _apiService.getParts();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inventory List', style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 8),
                    Text('Manage and track spare parts across all sectors.', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPartScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Part'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Controls (Search & Filter)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 768;
                return isDesktop
                    ? Row(
                        children: [
                          Expanded(child: _buildSearchBar(context)),
                          const SizedBox(width: 16),
                          _buildFilters(context),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSearchBar(context),
                          const SizedBox(height: 16),
                          _buildFilters(context),
                        ],
                      );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Data Table
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder<List<Part>>(
                    future: _partsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text('Error: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No parts found in inventory.'),
                        ));
                      }

                      final parts = snapshot.data!;

                      return DataTable(
                        headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerLow),
                        columns: const [
                          DataColumn(label: Text('')), // Checkbox placeholder if needed
                          DataColumn(label: Text('PART NAME', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('PART NUMBER', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('STOCK LEVEL', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('TREND', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: parts.map((part) {
                          Color statusBorderColor;
                          Color statusBgColor;
                          Color statusTextColor;
                          Color trendColor;
                          
                          if (part.quantityOnHand == 0) {
                            statusBorderColor = Theme.of(context).colorScheme.outline;
                            statusBgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
                            statusTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
                            trendColor = Theme.of(context).colorScheme.outline;
                          } else if (part.quantityOnHand <= part.reorderPoint) {
                            statusBorderColor = const Color(0xFFBA1A1A);
                            statusBgColor = const Color(0xFFFFDAD6);
                            statusTextColor = const Color(0xFF93000A);
                            trendColor = Theme.of(context).colorScheme.error;
                          } else {
                            statusBorderColor = const Color(0xFF008CC7);
                            statusBgColor = Theme.of(context).colorScheme.tertiaryContainer;
                            statusTextColor = Theme.of(context).colorScheme.onTertiaryContainer;
                            trendColor = Colors.green;
                          }

                          // Mock trend data for visualization purposes
                          final trendSpots = [10.0, 15.0, 12.0, part.quantityOnHand.toDouble()];

                          return _buildInventoryRow(
                            context,
                            part.name,
                            part.sku,
                            part.category ?? 'Uncategorized',
                            part.quantityOnHand.toString(),
                            part.status,
                            statusBorderColor,
                            statusBgColor,
                            statusTextColor,
                            trendColor,
                            trendSpots,
                          );
                        }).toList(),
                      );
                    }
                  ),
                ),
                Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Showing 1 to 5 of 124 entries', style: Theme.of(context).textTheme.bodySmall),
                      Row(
                        children: [
                          IconButton(onPressed: null, icon: const Icon(Icons.chevron_left)),
                          _buildPageButton(context, '1', true),
                          _buildPageButton(context, '2', false),
                          _buildPageButton(context, '3', false),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('...')),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by part name or number... (Ctrl + K)',
        prefixIcon: const Icon(Icons.search),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Row(
      children: [
        Text('STATUS:', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'All', true),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'In Stock', false),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Low Stock', false),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Out of Stock', false),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primaryFixed : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected ? Theme.of(context).colorScheme.onPrimaryFixed : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  DataRow _buildInventoryRow(BuildContext context, String name, String number, String category, String stockLevel, String status, Color statusBorderColor, Color statusBgColor, Color statusTextColor, Color trendColor, List<double> spots) {
    return DataRow(
      onSelectChanged: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PartDetailsScreen()),
        );
      },
      cells: [
        DataCell(Checkbox(value: false, onChanged: (v) {})),
        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(number, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        DataCell(Text(category)),
        DataCell(Text(stockLevel, style: TextStyle(fontWeight: FontWeight.bold, color: stockLevel == '12' ? Theme.of(context).colorScheme.error : null))),
        DataCell(
          SizedBox(
            width: 60,
            height: 24,
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
                    color: trendColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border(left: BorderSide(color: statusBorderColor, width: 2)),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: statusTextColor),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPageButton(BuildContext context, String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
