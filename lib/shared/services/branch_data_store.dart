import 'package:flutter/foundation.dart';

class BranchMetrics {
  final String id;
  final String name;
  final int memberCount;
  final int eventCount;
  final double activityRate; // in percentage e.g. 94.0
  final double growthRate;   // in percentage e.g. 45.0
  final String tag;
  final String province;

  const BranchMetrics({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.eventCount,
    required this.activityRate,
    required this.growthRate,
    this.tag = 'Branch',
    this.province = 'Bagmati',
  });
}

class BranchDataStore extends ChangeNotifier {
  static final BranchDataStore instance = BranchDataStore._internal();
  BranchDataStore._internal();

  final List<BranchMetrics> _branches = [
    const BranchMetrics(
      id: 'ktm',
      name: 'Kathmandu Branch',
      memberCount: 2850,
      eventCount: 32,
      activityRate: 88.0,
      growthRate: 22.0,
      tag: 'Head Branch',
      province: 'Bagmati',
    ),
    const BranchMetrics(
      id: 'pkr',
      name: 'Pokhara Branch',
      memberCount: 1980,
      eventCount: 24,
      activityRate: 94.0,
      growthRate: 29.0,
      tag: 'Regional Office',
      province: 'Gandaki',
    ),
    const BranchMetrics(
      id: 'cht',
      name: 'Chitwan Branch',
      memberCount: 1620,
      eventCount: 18,
      activityRate: 62.0,
      growthRate: 38.0,
      tag: 'Regional Office',
      province: 'Bagmati',
    ),
    const BranchMetrics(
      id: 'btw',
      name: 'Butwal Branch',
      memberCount: 1250,
      eventCount: 14,
      activityRate: 76.0,
      growthRate: 45.0,
      tag: 'Regional Office',
      province: 'Lumbini',
    ),
    const BranchMetrics(
      id: 'brt',
      name: 'Biratnagar Branch',
      memberCount: 950,
      eventCount: 10,
      activityRate: 68.0,
      growthRate: 16.0,
      tag: 'Regional Office',
      province: 'Koshi',
    ),
    const BranchMetrics(
      id: 'npj',
      name: 'Nepalgunj Branch',
      memberCount: 780,
      eventCount: 8,
      activityRate: 58.0,
      growthRate: 14.0,
      tag: 'Regional Office',
      province: 'Lumbini',
    ),
  ];

  List<BranchMetrics> get branches => List.unmodifiable(_branches);

  int get totalMembers => _branches.fold(0, (sum, b) => sum + b.memberCount);
  int get totalEvents => _branches.fold(0, (sum, b) => sum + b.eventCount);
  int get totalBranches => _branches.length;

  void addBranch(BranchMetrics branch) {
    _branches.add(branch);
    notifyListeners();
  }

  void updateBranchMembers(String id, int newCount) {
    final idx = _branches.indexWhere((b) => b.id == id);
    if (idx != -1) {
      final old = _branches[idx];
      _branches[idx] = BranchMetrics(
        id: old.id,
        name: old.name,
        memberCount: newCount,
        eventCount: old.eventCount,
        activityRate: old.activityRate,
        growthRate: old.growthRate,
        tag: old.tag,
        province: old.province,
      );
      notifyListeners();
    }
  }
}
