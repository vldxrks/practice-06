import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';
import '../models/profile_model.dart';
import '../widgets/build_probe.dart';
import 'profile_editor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    BuildProbe.hit('HomeScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій профіль'),
        actions: [
          IconButton(
            key: const Key('logout'),
            tooltip: 'Вийти',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthModel>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 28),
              const Center(
                child: CircleAvatar(
                  radius: 44,
                  child: Icon(Icons.person_outline, size: 48),
                ),
              ),
              const SizedBox(height: 24),
              const ProfileName(),
              const SizedBox(height: 8),
              const ProfileEmail(),
              const SizedBox(height: 32),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ПРО МЕНЕ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      ProfileBio(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('edit-profile'),
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  final profile = context.read<ProfileModel>().profile!;
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => ProfileEditor(initial: profile),
                    ),
                  );
                },
                label: const Text('Редагувати профіль'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ваші зміни діють протягом поточної сесії.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});
  @override
  Widget build(BuildContext context) {
    final name = context.select<ProfileModel, String>((model) => model.name);
    BuildProbe.hit('ProfileName');
    return Text(
      'Вітаємо, $name!',
      key: const Key('profile-name'),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
    );
  }
}

class ProfileEmail extends StatelessWidget {
  const ProfileEmail({super.key});
  @override
  Widget build(BuildContext context) {
    final email = context.select<ProfileModel, String>((model) => model.email);
    BuildProbe.hit('ProfileEmail');
    return Text(
      email,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black54),
    );
  }
}

class ProfileBio extends StatelessWidget {
  const ProfileBio({super.key});
  @override
  Widget build(BuildContext context) => Selector<ProfileModel, String>(
    selector: (_, model) => model.bio,
    builder: (_, bio, __) {
      BuildProbe.hit('ProfileBio');
      return Text(
        bio.isEmpty ? 'Опис ще не додано.' : bio,
        key: const Key('profile-bio'),
      );
    },
  );
}
