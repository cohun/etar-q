import 'dart:ffi';

import 'package:flutter/material.dart';

class AddSitesPage extends StatefulWidget {
  const AddSitesPage({super.key});
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AddSitesPage(), fullscreenDialog: true));
  }

  @override
  State<AddSitesPage> createState() => _AddSitesPageState();
}

class _AddSitesPageState extends State<AddSitesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.orange[800],
        title: const Text('Új üzemeltetési hely'),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildFormChildren(),
    ));
  }

  String _selectedValue = '1';
  List<String> list = <String>[
    'assets/images/worker1.jpg',
    'assets/images/factory1.jpg',
    'assets/images/truck1.jpg'
  ];
  List<String> listOfValue = ['1', '2', '3'];

  List<Widget> _buildFormChildren() {
    return [
      DropdownButtonFormField(
        value: _selectedValue,
        hint: const Text(
          'Válassz',
        ),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _selectedValue = value!;
          });
        },
        onSaved: (value) {
          setState(() {
            _selectedValue = value!;
          });
        },
        items: listOfValue.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Image.asset(
              list[listOfValue.indexOf(val)],
              height: 40,
            ),
          );
        }).toList(),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Megnevezés'),
      ),
    ];
  }
}
