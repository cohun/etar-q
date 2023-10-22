import 'package:flutter/material.dart';

const List<String> list = <String>[
  'assets/images/worker1.jpg',
  'assets/images/factory1.jpg',
  'assets/images/truck1.jpg'
];

class SitesPersonPage extends StatefulWidget {
  const SitesPersonPage({super.key});

  @override
  State<SitesPersonPage> createState() => _SitesPersonPageState();
}

class _SitesPersonPageState extends State<SitesPersonPage> {
  int what = 0;
  Widget _popupMenu() {
    return PopupMenuButton(
        child: Image.asset(
          list[what],
          width: 40,
        ),
        onSelected: (value) {
          setState(() {
            what = list.indexOf(value);
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
              singleCard("Kovács János"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange.shade800,
        tooltip: 'Új üzemeltető',
        child: const Icon(Icons.add),
      ),
    );
  }

  Card singleCard(String name) {
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
              onPressed: () {},
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
