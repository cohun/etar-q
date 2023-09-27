import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key, required this.user});
  final User user;

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
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
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(label: Text('Cég neve')),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text('Cég címe')),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Rögzítés'))
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
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Cég ETAR kód')),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Rögzítés'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
