import 'package:flutter/material.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Text('Form comes here'),
        ),
    );
  }
}