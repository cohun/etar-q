import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/features/sites/add_sites_page.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isApproved = false;

  Widget _popupMenu(void Function() tapped) {
    return PopupMenuButton(
        child: Image.asset(
          list[what],
          width: 40,
        ),
        onSelected: (value) {
          setState(() {
            tapped();
            isApproved ? what = list.indexOf(value) : what;
          });
        },
        itemBuilder: (BuildContext context) {
          return list.map((e) {
            return PopupMenuItem(
              value: e,
              // onTap: () => setState(() {
              //   dropdownValue = e;
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
    void tapped() {
      firestoreRepository.oneUserQuery(user!.uid).then(
            (value) => value.approvedRole == 'superSuper' ||
                    value.approvedRole == 'jogosultság osztó' ||
                    value.approvedRole == 'hyperSuper' ||
                    value.approvedRole == 'adminisztrátor' ||
                    value.approvedRole == 'admin'
                ? setState(() {
                    isApproved = true;
                  })
                : ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Ehhez adminisztrátori jogosultság szükséges!')),
                  ),
          );
    }

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
              singleCard("Kovács János", tapped),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tapped();
          if (isApproved) {
            AddSitesPage.show(context);
          }
        },
        backgroundColor: Colors.orange.shade800,
        tooltip: 'Új üzemeltető',
        child: const Icon(Icons.add),
      ),
    );
  }

  Card singleCard(String name, void Function() tapped) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _popupMenu(tapped),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: tapped,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
