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
  String dropdownValue = list.first;

  void _showDialog(BuildContext context) {
    int choiceBack = 0;
    void getValue(value) => choiceBack = value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _popupMenu(),
        );
      },
    );
  }

  Widget _popupMenu() {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
            value: value,
            leadingIcon: Image.asset(
              value,
              height: 40,
            ),
            label: '');
      }).toList(),
    );
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _popupMenu(),
                      const Text(
                        'POB902',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => _showDialog(context),
                        iconSize: 40,
                        icon: Image.asset(
                          dropdownValue,
                          height: 50,
                        ),
                      ),
                      const Text(
                        'Kovács Béla',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
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
}
