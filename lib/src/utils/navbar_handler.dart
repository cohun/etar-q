import 'package:etar_q/src/features/products/products_list/products_list_screen.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:etar_q/src/screens/home_screen.dart';
import 'package:etar_q/src/screens/sites_persons_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:etar_q/src/data/firestore_repository.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProductsListScreen(),
    Text(
      'Index 2: Dokumentumok',
      style: optionStyle,
    ),
    SitesPersonPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;
    void tapped(int index) {
      firestoreRepository.oneUserQuery(user!.uid).then(
            (value) => value.approvedRole == 'elbírálás alatt' ||
                    value.role == ''
                ? ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Jelenleg nincs ehhez jogosultságod!')),
                  )
                : setState(() {
                    _selectedIndex = index;
                  }),
          );
    }

    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Kezdőlap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.precision_manufacturing),
              label: 'Termékek',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.source),
              label: 'Dokumentumok',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Üzemeltetők',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.blueGrey,
          onTap: tapped,
        ));
  }
}
