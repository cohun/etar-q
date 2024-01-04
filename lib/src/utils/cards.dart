import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  const Cards(
      {super.key,
      this.name = '',
      this.company = '',
      this.address = '',
      this.counter = ''});
  final String name;
  final String company;
  final String address;
  final String counter;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Card(
            color: Colors.white,
            // color: const Color.fromARGB(255, 253, 253, 253),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Felhasználói adatok:',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.indigo, // optional
                    decorationThickness: 2, // optional
                    decorationStyle: TextDecorationStyle.solid, // optional
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_2_sharp),
                  title: Text(name),
                ),
                const Divider(
                  height: 20.0,
                ),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.threeLine,
                  leading: const Icon(Icons.factory),
                  trailing: const SizedBox(width: 30),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cég ETAR kód: $counter",
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  title: Column(
                    children: [
                      Text(
                        company,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        address,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
