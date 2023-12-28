// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:etar_q/src/data/firestore_repository.dart';
import 'package:etar_q/src/data/models/users.dart';
import 'package:etar_q/src/features/products/products_list/product_category_list_page.dart';
import 'package:etar_q/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:etar_q/src/common_widgets/custom_image.dart';
import 'package:etar_q/src/constants/app_sizes.dart';
import 'package:etar_q/src/data/models/product_category.dart';
import 'package:go_router/go_router.dart';

/// Used to show a single product inside a card.
class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.category,
    this.onPressed,
  });
  final Category category;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.read(firebaseAuthProvider).currentUser;

    final oneUser =
        ref.read(firestoreRepositoryProvider).oneUserQuery(user!.uid);

    return FutureBuilder(
        future: oneUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.company == '') {
              return const SizedBox.shrink();
            }
            Users data = snapshot.data as Users;
            var company = (data.company);

            return Card(
              color: Colors.white,
              elevation: 8,
              child: InkWell(
                key: productCardKey,
                onTap: () {
                  context
                      .goNamed('product', pathParameters: {"company": company});
                },
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomImage(
                        imageUrl: category.address,
                      ),
                      gapH8,
                      const Divider(),
                      gapH8,
                      Text(category.name, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
