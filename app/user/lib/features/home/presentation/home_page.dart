import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/legal_links.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openLegalLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIXO.GO User'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.policy_outlined),
            onSelected: (value) {
              if (value == 'terms') {
                _openLegalLink(context, LegalLinks.terms);
              } else {
                _openLegalLink(context, LegalLinks.privacy);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'terms', child: Text('Terms of Service')),
              PopupMenuItem(value: 'privacy', child: Text('Privacy Policy')),
            ],
          ),
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.go('/request'),
          icon: const Icon(Icons.car_repair),
          label: const Text('Request Roadside Assistance'),
        ),
      ),
    );
  }
}
