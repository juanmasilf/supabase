import 'package:supabase_flutter/supabase_flutter.dart';

class FoodDbService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;

  static Future<Map<String, dynamic>?> addFood({
    required String title,
    required String description,
    required String userId,
  }) async {
    final response = await _supabaseClient.from('foods').insert({
      'title': title,
      'description': description,
      'owner_id': userId,
    }).execute();
    if (response.hasError) {
      throw response.error!;
    }
    return response.data.first;
  }

  static Future<Map<String, dynamic>?> getFood(String id) async {
    final response = await _supabaseClient
        .from('foods')
        .select(
          '''
            id,
            title,
            description,
            created_at,
            owner:users (id, username, email)
            ''',
        )
        .eq(
          'id',
          id,
        )
        .single()
        .execute();

    if (response.hasError) {
      throw response.error!;
    }
    return response.data as Map<String, dynamic>?;
  }

  static Future<List<Map<String, dynamic>>?> getUserFoods(String userId) async {
    final response = await _supabaseClient
        .from('foods')
        .select()
        .eq(
          'owner_id',
          userId,
        )
        .order('created_at', ascending: false)
        .execute();

    if (response.hasError) {
      throw response.error!;
    }
    return (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  static Stream<List<Map<String, dynamic>>?> listenUserFoods(String userId) {
    return _supabaseClient.from('foods').stream(['id']).execute();
  }
}
