import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/users.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/utils/cards.dart';
import 'package:etar_q/src/utils/dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    );
  }
}

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key});

  void _showDialog(BuildContext context, Users users, WidgetRef ref) {
    String roleBack = users.approvedRole;
    void getValue(value) => roleBack = value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${users.name} jogosultsága"),
          content: SizedBox(
              width: 200,
              height: 40,
              child: Dropdown(
                users: users,
                valueDrop: getValue,
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
                  child: const Text("OK"),
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
        FutureBuilder(
            future: oneUser,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.company == '') {
                  return SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          const TextSpan(
                              text:
                                  "A saját fiók beállításokban (jobboldalt fent ikon) tudod a felhasználói nevedet megadni"),
                          style: TextStyle(color: Colors.amber.shade800),
                          textAlign: TextAlign.center,
                        ),
                        const Text('Csak ezután válassz céget!'),
                        FloatingActionButton(
                          heroTag: 'btn2',
                          child: const Icon(Icons.add),
                          onPressed: () {
                            ref
                                .read(firebaseAuthProvider)
                                .idTokenChanges()
                                .listen(
                              (User? user) {
                                if (user!.displayName == null) {
                                  print('User is currently signed out!');
                                } else {
                                  context.goNamed(AppRoute.addCompany.name,
                                      extra: user);
                                }
                              },
                            );

                            // final user = ref.read(firebaseAuthProvider).currentUser;
                            // ref.read(firestoreRepositoryProvider).addUsers(uid: user!.uid, company: 'company2',
                            // name: user.displayName.toString());
                          },
                        ),
                      ],
                    ),
                  );
                }
                Users data = snapshot.data as Users;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Cards(name: '${user.displayName}', company: data.company),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Összes felhasználó:"),
                      Expanded(
                        child: FirestoreListView<Users>(
                          query: firestoreRepository.usersQuery(),
                          itemBuilder: (BuildContext context,
                              QueryDocumentSnapshot<Users> doc) {
                            if (!doc.exists) {
                              return SizedBox(
                                height: 100,
                                width: 100,
                                child: FloatingActionButton(
                                  heroTag: 'btn2',
                                  child: const Icon(Icons.add),
                                  onPressed: () {
                                    final user = ref
                                        .read(firebaseAuthProvider)
                                        .currentUser;
                                    ref
                                        .read(firestoreRepositoryProvider)
                                        .addUsers(
                                            uid: user!.uid,
                                            company: 'company2',
                                            name: user.displayName.toString());
                                  },
                                ),
                              );
                            }
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
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }
}
