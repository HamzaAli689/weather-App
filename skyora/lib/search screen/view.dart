import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class Search screenPage extends StatelessWidget {
  const Search screenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Search screenLogic logic = Get.put(Search screenLogic());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search screenPage'),
      ),
      body: const Center(
        child: Text('Search screenPage'),
      ),
    );
  }
}
