import 'package:get/get.dart';

import '../model/task.dart';

class XPStateController extends GetxController {
  // einfacher Ansatz, um auf (beliebige) VerĂ¤nderungen zu reagieren
  var somethingChanged = 0.obs;

  void change() {
    somethingChanged++;
  }

  List<Task> taskListe= [];
}