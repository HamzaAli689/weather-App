import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardLogic logic = Get.put(DashboardLogic());

    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardPage'),
      ),
      body: const Center(
        child: Text('DashboardPage'),
      ),
    );
  }
}
