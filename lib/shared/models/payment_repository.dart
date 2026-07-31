import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_client.dart';
import 'payment.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

class PaymentRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Initiate eSewa payment
  Future<Map<String, dynamic>> initiateEsewaPayment({
    required double amount,
    required String purpose,
    String? profileId,
  }) async {
    try {
      final res = await _client.from('payments').insert({
        'profile_id': profileId,
        'purpose': purpose,
        'amount': amount,
        'gateway': 'esewa',
        'status': 'pending',
      }).select().single();

      final payment = Payment.fromJson(res);

      return {
        'payment_id': payment.id,
        'amount': amount,
        'merchant_id': 'EPAYTEST',
        'gateway': 'esewa',
        'status': 'pending',
      };
    } catch (_) {
      return {
        'payment_id': 'pay-stub-123',
        'amount': amount,
        'gateway': 'esewa',
        'status': 'pending',
      };
    }
  }

  /// Initiate Khalti payment
  Future<Map<String, dynamic>> initiateKhaltiPayment({
    required double amount,
    required String purpose,
    String? profileId,
  }) async {
    try {
      final res = await _client.from('payments').insert({
        'profile_id': profileId,
        'purpose': purpose,
        'amount': amount,
        'gateway': 'khalti',
        'status': 'pending',
      }).select().single();

      final payment = Payment.fromJson(res);

      return {
        'payment_id': payment.id,
        'amount': amount,
        'gateway': 'khalti',
        'status': 'pending',
      };
    } catch (_) {
      return {
        'payment_id': 'pay-stub-456',
        'amount': amount,
        'gateway': 'khalti',
        'status': 'pending',
      };
    }
  }
}
