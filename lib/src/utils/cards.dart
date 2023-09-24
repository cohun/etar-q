import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  const Cards(
      {super.key,
      this.name = '',
      this.company = '',
      this.address = '',
      this.approvedRole = 'elbírálás alatt',
      this.counter = ''});
  final String name;
  final String company;
  final String address;
  final String approvedRole;
  final String counter;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Card(
            color: const Color.fromARGB(255, 238, 241, 243),
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
                  subtitle: Text("Jogosultság: $approvedRole"),
                  title: Text(name),
                ),
                const Divider(
                  height: 20.0,
                ),

                ListTile(
                  leading: const Icon(Icons.factory),
                  subtitle: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cég ETAR kód: $counter",
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  title: Column(
                    children: [
                      Text(company),
                      Text(address),
                    ],
                  ),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     TextButton(
                //       child: const Text('BUY TICKETS'),
                //       onPressed: () {/* ... */},
                //     ),
                //     const SizedBox(width: 8),
                //     TextButton(
                //       child: const Text('LISTEN'),
                //       onPressed: () {/* ... */},
                //     ),
                //     const SizedBox(width: 8),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
