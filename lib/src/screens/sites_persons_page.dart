import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/features/sites/add_sites_page.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  Widget _popupMenu() {
    return PopupMenuButton(
        child: Image.asset(
          list[what],
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
    goBack() => context.goNamed(AppRoute.home.name);

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
                    if (apRol == 'superSuper' ||
                        apRol == 'jogosultság osztó' ||
                        apRol == 'hyperSuper' ||
                        apRol == 'adminisztrátor' ||
                        apRol == 'admin') {
                      isApproved = true;
                      company = snapshot.data!.company;
                      return singleCard();
                    } else {
                      return singleCard();
                    }
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
              ? AddSitesPage.show(context, company)
              : _notApprovedMessage();
        },
        backgroundColor: Colors.orange.shade800,
        tooltip: 'Új üzemeltető',
        child: const Icon(Icons.add),
      ),
    );
  }

  Card singleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _popupMenu(),
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
