import 'package:etar_q/src/common_widgets/action_text_button.dart';
import 'package:etar_q/src/constants/breakpoints.dart';
import 'package:etar_q/src/features/products/home_app_bar/shopping_cart_icon.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: const Text('Termékek'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.nfc),
            color: Colors.red,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.barcode_reader),
            color: Colors.orangeAccent,
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('Termékek'),
        actions: [
          ActionTextButton(
            text: 'NFC',
            onPressed: () {},
          ),
          ActionTextButton(
            text: 'QRCODE',
            onPressed: () {},
          ),
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
