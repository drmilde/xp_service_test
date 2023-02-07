import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xp_service_test/screens/service_screens/task_list_screen.dart';
import 'package:xp_service_test/services/controller/xp_state_controller.dart';

class StartScreen extends StatelessWidget {
  // erzeuge den XPStateController
  XPStateController _controller = Get.put(XPStateController());

  StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text("StartScreen"),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskListScreen()));
            },
            child: Text("zur App"),
          )
        ],
      ),
    ));
  }
}
