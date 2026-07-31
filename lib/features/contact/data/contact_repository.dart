import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../shared/models/contact_message.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository();
});

class ContactRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<bool> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _client.from('contact_messages').insert({
        'name': name,
        'email': email,
        'message': message,
        'status': 'new',
      });
      return true;
    } catch (_) {
      return true;
    }
  }

  Future<List<ContactMessage>> getMessages() async {
    try {
      final data = await _client
          .from('contact_messages')
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((json) => ContactMessage.fromJson(json))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
