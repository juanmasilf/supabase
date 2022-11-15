import 'package:supabase_flutter/supabase_flutter.dart';

class UserDbService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;

  static Future<Map<String, dynamic>?> addUser(
      {required String id,
      required String email,
      required String username}) async {
    final response = await _supabaseClient.from('users').insert({
      'id': id,
      'email': email,
      'username': username,
    }).execute();
    if (response.hasError) {
      throw response.error!;
    }
    return response.data.first;
  }

  static Future<Map<String, dynamic>?> getUser(String id) async {
    final response = await _supabaseClient
        .from('users')
        .select()
        .eq('id', id)
        .single()
        .execute();
    if (response.hasError) {
      throw response.error!;
    }
    return response.data;
  }
}
