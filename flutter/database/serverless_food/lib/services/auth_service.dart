import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabaseAuth = Supabase.instance.client.auth;

  static Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseAuth.signUp(
      email,
      password,
    );
    if (response.error != null) {
      throw response.error!;
    }
    return response.user;
  }

  static Future<Session?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseAuth.signIn(
      email: email,
      password: password,
    );
    return response.error == null ? response.data : null;
  }

  static Subscription? setAuthStateChangeAction(
      void Function(AuthChangeEvent, Session?) callback) {
    return _supabaseAuth.onAuthStateChange(callback).data;
  }

  static Session? getCurrentSession() {
    return _supabaseAuth.currentSession;
  }

  static Future<void> signOut() async {
    await _supabaseAuth.signOut();
  }
}
