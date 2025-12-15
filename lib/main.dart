import 'package:cms/globals/site_service.dart';
import 'package:cms/globals/labor_service.dart';
import 'package:cms/pages/Auth/login_screen.dart';
import 'package:cms/pages/Dashboard/admin_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cms/globals/auth_service.dart';
import 'package:cms/globals/app_state.dart';
import 'firebase_options.dart';
import 'package:cms/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sharedPrefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<SiteService>(
          create: (_) => SiteService(),
        ),
        ChangeNotifierProvider<LaborService>(
          create: (_) => LaborService(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            theme: appState.theme,
            home: const SplashScreen(),
            routes: {
              'HomePage': (context) => const LoginScreen(),
              'AdminDashboard': (context) => const AdminDashboard(),
            },
          );
        },
      ),
    );
  }
}
