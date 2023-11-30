import 'dart:io';

import 'package:etar_q/src/common_widgets/responsive_center.dart';
import 'package:etar_q/src/constants/app_sizes.dart';
import 'package:etar_q/src/constants/product_categories.dart';
import 'package:etar_q/src/features/products/home_app_bar/home_app_bar.dart';
import 'package:etar_q/src/features/products/products_list/products_grid.dart';
import 'package:etar_q/src/features/products/products_list/products_search_text_field.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Shows the list of products with a search field at the top.
class ProductCategoryListPage extends StatefulWidget {
  const ProductCategoryListPage({super.key});

  @override
  State<ProductCategoryListPage> createState() =>
      _ProductCategoryListPageState();
}

class _ProductCategoryListPageState extends State<ProductCategoryListPage> {
  // * Use a [ScrollController] to register a listener that dismisses the
  // * on-screen keyboard when the user scrolls.
  // * This is needed because this page has a search field that the user can
  // * type into.
  final _scrollController = ScrollController();
  var selectedExcel = Excel.createExcel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  // When the search text field gets the focus, the keyboard appears on mobile.
  // This method is used to dismiss the keyboard when the user scrolls.
  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    // if (result != null) {
    //   var bytes = result.files.single.bytes;
    //   var excel = Excel.decodeBytes(bytes!);
    //   for (var table in excel.tables.keys) {
    //     print(table); //sheet Name
    //     print(excel.tables[table]!.maxColumns);
    //     print(excel.tables[table]!.maxRows);
    //     for (var row in excel.tables[table]!.rows) {
    //       print('$row');
    //     }
    //   }
    // }

    if (result != null) {
      File file = File(result.files.single.path!);

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      selectedExcel = excel;
      print(selectedExcel["Munka1"].sheetName);
      Sheet sheet = selectedExcel["Munka1"];
      var sheetName = sheet.sheetName;

      getList(sheetName);
    } else {
      // User canceled the picker
    }
    print("The final List of List Length is ${selectedExcel.tables.length}");
  }

  getList(sheetName) async {
    selectedExcel.tables.clear();
    //
    print(selectedExcel["Munka1"].rows.length);
    for (var row in selectedExcel.tables[sheetName]!.rows) {
      if (row[0]!.props.isNotEmpty) {
        print(row[0]?.props.first);
        print(row[1]?.props.first);
      }

      //tbleRows.add(row);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const ResponsiveSliverCenter(
            padding: EdgeInsets.all(Sizes.p16),
            child: ProductsSearchTextField(),
          ),
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              children: [
                TextButton(
                    onPressed: pickFile,
                    child: const Text(
                      "Pick from storage",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
