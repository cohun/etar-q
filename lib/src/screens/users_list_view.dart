import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/users.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/utils/cards.dart';
import 'package:etar_q/src/utils/dropdown.dart';
import 'package:etar_q/src/utils/test_users_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UsersListView extends ConsumerWidget {
  const UsersListView({super.key});

  void _showDialog(
      BuildContext context, Users users, WidgetRef ref, bool isHyperSuper) {
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
            child: users.role == 'super' && !isHyperSuper
                ? const Text('Te vagy a jogosultság osztó')
                : Dropdown(
                    users: users,
                    valueDrop: getValue,
                  ),
          ),
          actions: [
            users.role == 'super' && !isHyperSuper
                ? MaterialButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : Row(
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
                          roleBack == "felhasználó törlése"
                              ? ref
                                  .read(firestoreRepositoryProvider)
                                  .deleteUsers(uid: users.uid)
                              : ref
                                  .read(firestoreRepositoryProvider)
                                  .updateUsers(
                                      uid: users.uid, approvedRole: roleBack);
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
        ref.watch(firestoreRepositoryProvider).oneUserStream(user!.uid);

    return Column(
      children: [
        StreamBuilder(
            stream: oneUser,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                );
              }
              if (snapshot.connectionState != ConnectionState.waiting) {
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
                                if (user?.displayName == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 6),
                                        content: Text(
                                            'Kattints először jobbra fent a fiók ikonra és töltsd ki a felhasználói neved!')),
                                  );
                                } else {
                                  context.goNamed(AppRoute.addCompany.name,
                                      extra: user);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                Users data = snapshot.data as Users;
                final oneCounter = ref
                    .read(firestoreRepositoryProvider)
                    .counterCompany(data.company)
                    .then((value) {
                  return value;
                });

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder(
                          future: oneCounter,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                "Something went wrong",
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              const UserInformation();
                              return Cards(
                                  name: '${user.displayName}',
                                  company: data.company,
                                  address: snapshot.data!.address,
                                  counter: snapshot.data!.counter.toString());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      data.approvedRole == 'hyper' ||
                              data.approvedRole == 'hyperSuper' ||
                              data.role == 'hyperSuper'
                          ? TextButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.pinkAccent)),
                              child: const Text('CÉGVÁLTÁS'),
                              onPressed: () =>
                                  context.goNamed(AppRoute.companies.name),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Összes felhasználó:",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.indigo, // optional
                          decorationThickness: 2, // optional
                          decorationStyle:
                              TextDecorationStyle.solid, // optional
                        ),
                      ),
                      data.role == 'hyperSuper'
                          ? superUsers(firestoreRepository, ref)
                          : companyUsers(firestoreRepository, data, ref),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }

  Expanded companyUsers(
      FirestoreRepository firestoreRepository, Users data, WidgetRef ref) {
    print(data.company);

    return Expanded(
      child: FirestoreListView<Users>(
        query: firestoreRepository.usersQuery(data.company),
        itemBuilder: (BuildContext context, QueryDocumentSnapshot<Users> doc) {
          if (!doc.exists) {
            return const SizedBox.shrink();
          }
          final users = doc.data();
          return Column(
            children: [
              users.approvedRole == 'hyper' ||
                      users.approvedRole == 'hyperSuper'
                  ? const SizedBox.shrink()
                  : users.approvedRole == 'elbírálás alatt'
                      ? ListTile(
                          hoverColor: Colors.amber,
                          selectedColor: Colors.amber,
                          leading: const Icon(Icons.person_2_outlined,
                              color: Colors.red),
                          title: Text(users.name),
                          subtitle: Text(users.approvedRole),
                          onTap: () {
                            if (data.approvedRole == 'jogosultság osztó') {
                              _showDialog(context, users, ref, false);
                            }
                          },
                        )
                      : ListTile(
                          hoverColor: Colors.amber,
                          selectedColor: Colors.amber,
                          leading: const Icon(Icons.person_2_outlined,
                              color: Colors.green),
                          title: Text(users.name),
                          subtitle: Text(users.approvedRole),
                          onTap: () {
                            if (data.approvedRole == 'jogosultság osztó') {
                              _showDialog(context, users, ref, false);
                            }
                          },
                        ),
              users.approvedRole == 'hyper' ||
                      users.approvedRole == 'hyperSuper'
                  ? const SizedBox.shrink()
                  : const Divider(
                      color: Colors.black45,
                      height: 8,
                    ),
            ],
          );
        },
      ),
    );
  }

  Expanded superUsers(FirestoreRepository firestoreRepository, WidgetRef ref) {
    return Expanded(
      child: FirestoreListView<Users>(
        query: firestoreRepository.superUsers(),
        itemBuilder: (BuildContext context, QueryDocumentSnapshot<Users> doc) {
          if (!doc.exists) {
            return const SizedBox.shrink();
          }
          final users = doc.data();
          return Column(
            children: [
              users.approvedRole == 'elbírálás alatt'
                  ? ListTile(
                      hoverColor: Colors.amber,
                      selectedColor: Colors.amber,
                      leading: const Icon(Icons.person_2_outlined,
                          color: Colors.red),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users.name),
                          Text(
                            users.company,
                            style: const TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      subtitle: Text(users.approvedRole),
                      onTap: () {
                        _showDialog(context, users, ref, true);
                      },
                    )
                  : ListTile(
                      hoverColor: Colors.amber,
                      selectedColor: Colors.amber,
                      leading: const Icon(Icons.person_2_outlined,
                          color: Colors.green),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users.name),
                          Text(
                            users.company,
                            style: const TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      subtitle: Text(users.approvedRole),
                      onTap: () {
                        _showDialog(context, users, ref, true);
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
    );
  }
}
