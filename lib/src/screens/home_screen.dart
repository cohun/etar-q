import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/users.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/utils/cards.dart';
import 'package:etar_q/src/utils/dropdown.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

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
      body: const UsersListView(),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     TextButton(
      //                 child: const Text('BUY TICKETS'),
      //                 onPressed: () {/* ... */},
      //               ),
      //     FloatingActionButton(
      //       heroTag: 'btn1',
      //       child: const Icon(Icons.add),
      //       onPressed: () {
      //         final user = ref.read(firebaseAuthProvider).currentUser;
      //         ref.read(firestoreRepositoryProvider).addUsers(uid: user!.uid, company: 'company',
      //         name: user.displayName.toString());
      //       },
      //     ),
      //     FloatingActionButton(
      //       heroTag: 'btn2',
      //       child: const Icon(Icons.add),
      //       onPressed: () {

      //         ref.read(firestoreRepositoryProvider).addCounter(counter: "11201", company: "H-ITB Kft.", address: "1119 Budapest Kelenvölgyi htsr. 5");
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key});

  void _showDialog(BuildContext context, Users users, WidgetRef ref) {
    String roleBack = users.approvedRole;
    void Value(value) => roleBack = value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${users.name} jogosultsága"),
          content: Container(
              width: 200,
              height: 40,
              child: Dropdown(
                users: users,
                valueDrop: Value,
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  child: const Text("Mégse"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    ref
                        .read(firestoreRepositoryProvider)
                        .updateUsers(uid: users.uid, approvedRole: roleBack);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;
    final oneUser =
        ref.read(firestoreRepositoryProvider).oneUserQuery(user!.uid);
    return Column(
      children: [
        Cards(name: '${user!.displayName}', company: 'comp'),
        const SizedBox(
          height: 10,
        ),
        const Text("Összes felhasználó:"),
        Expanded(
          child: FirestoreListView<Users>(
            query: firestoreRepository.usersQuery(),
            itemBuilder:
                (BuildContext context, QueryDocumentSnapshot<Users> doc) {
              final users = doc.data();
              return Column(
                children: [
                  ListTile(
                    hoverColor: Colors.amber,
                    selectedColor: Colors.amber,
                    leading: const Icon(Icons.person_2_outlined),
                    title: Text(users.name),
                    subtitle: Text(users.approvedRole),
                    onTap: () {
                      _showDialog(context, users, ref);
                    },
                  ),
                  const Divider(
                    color: Colors.black45,
                    height: 8,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
