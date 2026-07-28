import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class Search_screenPage extends StatelessWidget {
  const Search_screenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Search_screenLogic logic = Get.put(Search_screenLogic());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search_screenPage'),
      ),
      body: const Center(
        child: Text('Search_screenPage'),
      ),
    );
  }
}
