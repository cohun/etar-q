
import 'package:etar_q/src/screens/ui_auth_providers.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ETAR.jpg', height: 40,),
            const SizedBox(width: 12,),
            const Text('Bejelentkezés'),
          ],
        ),
      ),
      body: SignInScreen(
        providers: authProviders,
       
        headerBuilder: (context, constraints, shrinkOffset
) {
             return Padding(
               padding: const EdgeInsets.all(20),
               child: AspectRatio(
                 aspectRatio: 1,
                 child: Image.asset('assets/images/image.jpg'),
               ),
             );
           },
           subtitleBuilder: (context, action) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: action == AuthAction.signIn
                          ? const Text(
                              'Üdvözlünk az ETAR applikációban, jelenkezz be a fiókodba!')
                          : const Text(
                              'Üdvözlünk az ETAR applikációban, hozz létre egy fiókot!'),
                    );
                  },
           footerBuilder: (context, action) {
             return const Padding(
               padding: EdgeInsets.only(top: 16),
               child: Text(
                 'Bejelentkezés esetén elfogadod a használati feltételeket és az adatvédelmi szabályzatot.',
                 style: TextStyle(color: Colors.grey),
               ),
             );
           },
           sideBuilder: (context, shrinkOffset) {
             return Padding(
               padding: const EdgeInsets.all(20),
               child: AspectRatio(
                 aspectRatio: 1,
                 child: Image.asset('assets/images/image.jpg'),
               ),
             );
           },
      ),
    );
  }
}