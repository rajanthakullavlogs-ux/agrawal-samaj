import 'package:flutter/foundation.dart';

@immutable
class Payment {
  final String id;
  final String? profileId;
  final String? purpose;
  final String? referenceId;
  final double amount;
  final String? gateway;
  final String? gatewayTxnId;
  final String status;
  final DateTime createdAt;

  const Payment({
    required this.id,
    this.profileId,
    this.purpose,
    this.referenceId,
    required this.amount,
    this.gateway,
    this.gatewayTxnId,
    this.status = 'pending',
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      profileId: json['profile_id'] as String?,
      purpose: json['purpose'] as String?,
      referenceId: json['reference_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      gateway: json['gateway'] as String?,
      gatewayTxnId: json['gateway_txn_id'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
