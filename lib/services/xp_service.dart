import 'package:xp_service_test/services/model/task.dart';

import 'xpbackend_service_provider.dart';
import 'model/object_not_found_exception.dart';

class XPService {
  /* Nutzer */

  Future<List<Task>> getTaskList() async {
    return await XPBackendServiceProvider.getObjectList<Task>(
        resourcePath: "tasks", parseBody: taskListFromJson);
  }

  Future<Task> getTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.getObjectById<Task>(
      id: id,
      resourcePath: "tasks",
      parseBody: taskFromJson,
    );

    if (result.isEmpty) {
      throw ObjectNotFoundException();
    }

    return result[0];
  }

  Future<bool> updateTaskById({required int id, required Task data}) async {
    var result = await XPBackendServiceProvider.updateObjectById<Task>(
        id: id, data: data, resourcePath: "tasks", toJson: taskToJson);
    return result;
  }

  Future<bool> deleteTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.deleteObjectById(
      id: id,
      resourcePath: "tasks",
    );
    return result;
  }
}
