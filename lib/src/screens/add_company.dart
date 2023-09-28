import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key, required this.user});
  final User user;

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _compKey = GlobalKey<FormState>();
  final _counterKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _addressController;
  late final TextEditingController _counterController;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController();
    _addressController = TextEditingController();
    _counterController = TextEditingController();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _addressController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cég megadása'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              widget.user.displayName!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Amennyiben egy az ETAR-ba már felvett cégebe jelentkezel, csak a jogosultság osztótól'
              ' kapott ETAR kódot írd be alulra. Csupán ha új céget viszel be, akkor kell megadni a cég adatokat!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _compKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(label: Text('Cég neve')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nem lehet üres';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(label: Text('Cég címe')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nem lehet üres';
                      }

                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_compKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${_companyController.text} cég rögzítve')),
                          );
                        }
                      },
                      child: Text('Rögzítés'))
                ],
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ha rendelkezel a cég ETAR kódjával a belépéshez, itt alább megadhatod!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _counterKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _counterController,
                    decoration:
                        const InputDecoration(label: Text('Cég ETAR kód')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nem lehet üres';
                      }
                      bool counterlValid = RegExp(r"^[0-9]*$").hasMatch(value);

                      if (!counterlValid) {
                        return 'Csak számok lehetnek!';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_counterKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${_counterController.text} ETAR kód rögzítve')),
                          );
                        }
                      },
                      child: Text('Rögzítés'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
