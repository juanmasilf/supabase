import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;

  static Future<String> uploadFile(File file, String name) async {
    final extension = file.path.split('.').last;
    final fileName = '$name.$extension';
    final storageResponse =
        await _supabaseClient.storage.from('images').upload(fileName, file);

    if (storageResponse.hasError) {
      throw Exception(storageResponse.error!.message);
    }
    final imageUrlResponse =
        _supabaseClient.storage.from('images').getPublicUrl(fileName);

    if (imageUrlResponse.hasError || imageUrlResponse.data == null) {
      throw Exception(imageUrlResponse.error!.message);
    }

    return imageUrlResponse.data!;
  }
}
