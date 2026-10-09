import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_model.dart';
import 'models/profile_model.dart';
import 'services/fake_api.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/build_probe.dart';

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key, this.api});
  final FakeApi? api;
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<FakeApi>(
        create: (_) =>
            api ??
            FakeApi(
              failFirstRequest: const bool.fromEnvironment(
                'FAIL_FIRST_REQUEST',
              ),
            ),
      ),
      ChangeNotifierProvider(create: (_) => ProfileModel()),
      ChangeNotifierProvider(
        create: (context) =>
            AuthModel(context.read<FakeApi>(), context.read<ProfileModel>()),
      ),
    ],
    child: MaterialApp(
      title: 'Особистий простір',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'EvidenceFont',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF356859)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F2),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const AuthGate(),
    ),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final authenticated = context.select<AuthModel, bool>(
      (model) => model.isAuthenticated,
    );
    BuildProbe.hit('AuthGate');
    return authenticated ? const HomeScreen() : const LoginScreen();
  }
}
