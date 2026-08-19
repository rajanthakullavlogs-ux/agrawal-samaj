import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'branch_admin_nav_bar.dart';

class BranchAdminShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BranchAdminShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BranchAdminBottomNavBar(
        activeIndex: navigationShell.currentIndex,
        navigationShell: navigationShell,
      ),
    );
  }
}
