import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CounterController extends GetxController {
  var count = 0.obs;
  final storage = GetStorage();

  CounterController() {
    count.value = storage.read("counter") ?? 0;
  }

  void increment() {
    count.value++;
    storage.write("counter", count.value);
  }
}

class CounterScreen extends StatelessWidget {
  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Obx(() => Text("Count: ${counterController.count}", style: TextStyle(fontSize: 24))),
          ElevatedButton(onPressed: counterController.increment, child: Text("Increment"))
        ],
      ),
    );
  }
}
