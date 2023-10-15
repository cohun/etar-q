// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:etar_q/src/common_widgets/custom_image.dart';
import 'package:etar_q/src/constants/app_sizes.dart';
import 'package:etar_q/src/data/models/product_category.dart';

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
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
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
}
