import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/fixed_deposit_controller.dart';

class FixedDepositView extends GetView<FixedDepositController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FixedDepositView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'FixedDepositView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
