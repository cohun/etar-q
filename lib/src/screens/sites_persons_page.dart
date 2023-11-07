import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/models/sites_persons_model.dart';
import 'package:etar_q/src/features/sites/add_sites_page.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> list = <String>[
  'assets/images/worker1.jpg',
  'assets/images/factory1.jpg',
  'assets/images/truck1.jpg'
];

class SitesPersonPage extends ConsumerStatefulWidget {
  const SitesPersonPage({super.key});

  @override
  ConsumerState<SitesPersonPage> createState() => _SitesPersonPageState();
}

class _SitesPersonPageState extends ConsumerState<SitesPersonPage> {
  int what = 0;
  String name = 'Kovács János';
  bool isApproved = false;
  String company = '';

  Widget _popupMenu(String name, int what) {
    return PopupMenuButton(
        child: Image.asset(
          list[what - 1],
          width: 40,
        ),
        onSelected: (value) {
          setState(() {
            isApproved ? what = list.indexOf(value) : _notApprovedMessage();
          });
        },
        itemBuilder: (BuildContext context) {
          return list.map((e) {
            return PopupMenuItem(
              value: e,
              // onTap: () => setState(() {
              //   tapped();
              //   isApproved ? what = list.indexOf(e) : what;
              // }),
              child: Image.asset(
                e,
                height: 30,
              ),
            );
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;

    final oneUser = firestoreRepository.oneUserStream(user!.uid);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Üzemeltetés helyszínei, üzemeltetők',
          style: TextStyle(fontSize: 18),
        ),
        elevation: 2.0,
        backgroundColor: Colors.orange[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: oneUser,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                    );
                  }
                  if (snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.hasData) {
                    final apRol = snapshot.data?.approvedRole;
                    final company = snapshot.data!.company;
                    if (apRol == 'superSuper' ||
                        apRol == 'jogosultság osztó' ||
                        apRol == 'hyperSuper' ||
                        apRol == 'adminisztrátor' ||
                        apRol == 'admin') {
                      isApproved = true;
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 1200,
                          child: FirestoreListView(
                            query: firestoreRepository.sitesQuery(company),
                            itemBuilder: (BuildContext context,
                                QueryDocumentSnapshot<SitesPersonsModel> doc) {
                              return singleCard(doc['name'], doc['what']);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isApproved
              ? AddSitesPage.show(context, user.uid)
              : _notApprovedMessage();
        },
        backgroundColor: Colors.orange.shade800,
        tooltip: 'Új üzemeltető',
        child: const Icon(Icons.add),
      ),
    );
  }

  Card singleCard(String name, int what) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _popupMenu(name, what),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: isApproved ? _deleteCard : _notApprovedMessage,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  _notApprovedMessage() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ehhez adminisztrátori jogosultság szükséges!')),
      );

  _deleteCard() {}
}

class SitesListView extends ConsumerWidget {
  const SitesListView(this.company, {super.key});
  final String company;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    return FirestoreListView(
      query: firestoreRepository.sitesQuery(company),
      itemBuilder:
          (BuildContext context, QueryDocumentSnapshot<SitesPersonsModel> doc) {
        return const SizedBox.shrink();
      },
    );
  }
}
