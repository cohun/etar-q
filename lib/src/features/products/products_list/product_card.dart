
import 'package:etar_q/src/constants/app_sizes.dart';
import 'package:etar_q/src/data/models/product_model.dart';
import 'package:flutter/material.dart';
;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used to show a single product inside a card.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.onPressed});
  final ProductModel product;
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
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              Text(product.type, style: Theme.of(context).textTheme.titleLarge),
              if (product.nfc.isNotEmpty) ...[
                gapH8,
                 Text(product.nfc, style: Theme.of(context).textTheme.titleLarge),
              ],
              gapH24,
              Text(product.description,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH4,
              Text(product.capacity,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}