import 'package:flutter/foundation.dart';

@immutable
class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final String status;
  final DateTime createdAt;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    this.status = 'new',
    required this.createdAt,
  });

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      status: json['status'] as String? ?? 'new',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'email': email,
      'message': message,
    };
  }
}
