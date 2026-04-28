import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/stock_movement_screen.dart';
import 'screens/suppliers_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const IMSApp());
}

class IMSApp extends StatelessWidget {
  const IMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory System',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: FutureBuilder<String?>(
        future: ApiService.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainShell();
          }
          return const LoginScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const InventoryScreen(),
    const StockMovementScreen(),
    const SuppliersScreen(),
    const Scaffold(body: Center(child: Text('Settings / Reports'))),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Inventory System',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 1.0,
                ),
              ),
            ),
      // drawer: isDesktop ? null : _buildDrawer(), // Removed drawer for mobile, relying on BottomNavigationBar
      body: Row(
        children: [
          if (isDesktop) _buildDesktopDrawer(),
          if (isDesktop)
            Container(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildDesktopHeader(),
                if (isDesktop)
                  Container(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                Expanded(child: _screens[_currentIndex]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1.0),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
                selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                unselectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.normal),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    activeIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2_outlined),
                    activeIcon: Icon(Icons.inventory_2),
                    label: 'Inventory',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.swap_horiz_outlined),
                    activeIcon: Icon(Icons.swap_horiz),
                    label: 'In/Out',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_shipping_outlined),
                    activeIcon: Icon(Icons.local_shipping),
                    label: 'Vendors',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      height: 64,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Inventory System',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }



  Widget _buildDesktopDrawer() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          width: 288,
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          child: _buildDrawerContent(),
        ),
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                backgroundImage: const NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDQrGiEOAZ29G0iKppHUWvyIWXx4ECL9-hO3oi2wMAFeAodjB8dTYwdcnKU7iT9Yp8DkzFoKMayeCUSR2tNYhHvyDEjkJyAQ01o6x85gMYa93nzomU6TtSBBq63Szmu7jOU2bqvTKJmRerU5vC-KrP4RfelT_RTtHeWSPwPb3qZw4hq6-U2M5AyR6cIYAnWrC_ObM_kYRa5Z36PKfa53jrhb86drJv7oMu24SbQDZ2xh0nvZgoQ8kqBu_mYxbcxujZy8BLUjfLSaw',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Warehouse Manager',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Industrial Sector A',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildDrawerItem(
          icon: Icons.analytics,
          label: 'Dashboard',
          index: 0,
        ),
        _buildDrawerItem(
          icon: Icons.list_alt,
          label: 'Parts List',
          index: 1,
        ),
        _buildDrawerItem(
          icon: Icons.move_to_inbox,
          label: 'Stock Movement',
          index: 2,
        ),
        _buildDrawerItem(
          icon: Icons.factory_outlined,
          label: 'Suppliers',
          index: 3,
        ),
        _buildDrawerItem(
          icon: Icons.assessment_outlined,
          label: 'Reports',
          index: 4,
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          setState(() => _currentIndex = index);
          if (MediaQuery.of(context).size.width < 768 && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.surfaceContainerHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border(left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4))
                : const Border(left: BorderSide(color: Colors.transparent, width: 4)),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
