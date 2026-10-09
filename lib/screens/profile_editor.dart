import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import '../models/user_profile.dart';
import '../widgets/build_probe.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({super.key, required this.initial});
  final UserProfile initial;
  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late final TextEditingController _name;
  late final TextEditingController _bio;
  String? _error;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _bio = TextEditingController(text: widget.initial.bio);
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    final error = context.read<ProfileModel>().update(
      name: _name.text,
      bio: _bio.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    BuildProbe.hit('ProfileEditor');
    return Scaffold(
      appBar: AppBar(title: const Text('Редагування профілю')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Розкажіть про себе',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text('Ім’я та опис видно на головному екрані.'),
              const SizedBox(height: 28),
              TextField(
                key: const Key('edit-name'),
                controller: _name,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Ім’я'),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('edit-bio'),
                controller: _bio,
                maxLength: 160,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Про мене'),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('save-profile'),
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Зберегти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
