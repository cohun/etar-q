import 'package:flutter/material.dart';

class SitesPersonPage extends StatelessWidget {
  const SitesPersonPage({super.key});

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
                      IconButton(
                        iconSize: 40,
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/truck1.jpg',
                          height: 40,
                        ),
                      ),
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
                        onPressed: () {},
                        iconSize: 40,
                        icon: Image.asset(
                          'assets/images/worker1.jpg',
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
