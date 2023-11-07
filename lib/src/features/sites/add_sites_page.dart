import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/models/sites_persons_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSitesPage extends ConsumerStatefulWidget {
  const AddSitesPage({super.key, required this.uid});
  final String uid;
  static Future<void> show(BuildContext context, String uid) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddSitesPage(
              uid: uid,
            ),
        fullscreenDialog: true));
  }

  @override
  ConsumerState<AddSitesPage> createState() => _AddSitesPageState();
}

class _AddSitesPageState extends ConsumerState<AddSitesPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedValue = '1';
  String _name = '';

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit(FirestoreRepository firestoreRepository) {
    final s = _name;
    final what = int.tryParse(_selectedValue)!;
    if (_validateAndSaveForm()) {
      final site = SitesPersonsModel(name: s, what: what);
      print("What: ${site.what}");
      print("Name: ${site.name}");
      print(widget.uid);
      firestoreRepository.oneUserQuery(widget.uid).then((value) {
        firestoreRepository.createSite(site, value.company);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.orange[800],
        title: const Text('Új üzemeltetési hely'),
        actions: [
          TextButton(
              onPressed: () => _submit(firestoreRepository),
              child: const Text(
                'Mentés',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
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
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<String> list = <String>[
    'assets/images/worker1.jpg',
    'assets/images/factory1.jpg',
    'assets/images/truck1.jpg'
  ];
  List<String> listText = ['dolgozó', 'munkahely', 'gépjármű'];
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  list[listOfValue.indexOf(val)],
                  height: 40,
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(listText[listOfValue.indexOf(val)]),
              ],
            ),
          );
        }).toList(),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Megnevezés'),
        onSaved: (value) => _name = value!,
        onChanged: (value) {
          setState(() {
            _name = value;
          });
        },
        validator: (value) => value!.isNotEmpty ? null : 'Kérem kitölteni!',
      ),
    ];
  }
}
