import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/models/counter.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/models/users.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CompanyList extends ConsumerWidget {
  const CompanyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;

    final oneUser =
        ref.read(firestoreRepositoryProvider).oneUserQuery(user!.uid);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                    return const SizedBox.shrink();
                  }
                  Users data = snapshot.data as Users;

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        companyList(firestoreRepository, user.uid, data, ref),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  Expanded companyList(FirestoreRepository firestoreRepository, String uid,
      Users data, WidgetRef ref) {
    return Expanded(
      child: FirestoreListView<Counter>(
        query: firestoreRepository.allCounter(),
        itemBuilder:
            (BuildContext context, QueryDocumentSnapshot<Counter> doc) {
          if (!doc.exists) {
            return const SizedBox.shrink();
          }
          final companies = doc.data();
          return Column(
            children: [
              ListTile(
                hoverColor: Colors.amber,
                selectedColor: Colors.amber,
                leading: const Icon(Icons.person_2_outlined, color: Colors.red),
                title: Text(companies.company),
                subtitle: Text(companies.address),
                onTap: () {
                  ref.read(firestoreRepositoryProvider).updateUsers(
                      uid: uid,
                      approvedRole: data.approvedRole,
                      company: companies.company);
                  context.goNamed(AppRoute.home.name);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const HomeScreen(),
                  //   maintainState: false,
                  // ));
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const BottomNavigation(),
                  //     maintainState: false,
                  //   ),
                  // );
                  // Navigator.of(context).pop(true);
                  // Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration: const Duration(seconds: 7),
                        content: Text(
                            '${companies.company} céghez vagy bejelentkezve')),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
