import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/models/users.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/screens/users_list_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cég és jogosultság adatok'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.goNamed(AppRoute.profile.name),
        )
      ]),
      body: const SingleChildScrollView(child: UsersListView()),
    );
  }
}
