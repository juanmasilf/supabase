import 'package:flutter/material.dart';
import 'package:serverless_food/screens/add_food_screen.dart';
import 'package:serverless_food/screens/home_screen.dart';
import 'package:serverless_food/screens/login_screen.dart';
import 'package:serverless_food/screens/register_screen.dart';
import 'package:serverless_food/screens/search_screen.dart';
import 'package:serverless_food/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ckhjmyffwkwkehzdctji.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNraGpteWZmd2t3a2VoemRjdGppIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjYwNTU5NTcsImV4cCI6MTk4MTYzMTk1N30.RyE8QK1oT5j4RrHZvpsmWfiX3A1c1qCmheut-JZRrsY',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        focusColor: Colors.black,
        colorScheme: const ColorScheme(
          primary: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          secondary: Colors.white,
          onBackground: Colors.white,
          background: Colors.white,
          onError: Colors.red,
          error: Colors.red,
          onSurface: Colors.grey,
          surface: Colors.grey,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => LogInScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => HomeScreen(),
        '/add': (_) => const AddFoodScreen(),
        '/search': (_) => const SearchScreen(),
      },
    );
  }
}
