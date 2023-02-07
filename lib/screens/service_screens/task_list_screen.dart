import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xp_service_test/services/controller/xp_state_controller.dart';

import '../../services/model/task.dart';
import '../../services/xp_service.dart';
import '../../services/xpbackend_service_provider.dart';
import 'task_edit_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  XPStateController _controller = Get.find();

  XPService service = XPService();
  List<Task> tasks = [];

  // Load to-do list from the server
  Future<bool> _loadUsers() async {
    tasks = await service.getTaskList();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task Liste"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Task task = Task(
              id: 0,
              category: "category",
              hasRewardXp: [],
              rewardCoins: 0,
              rewardTickets: 0,
              title: "Neuer Task",
            );

            bool result = await XPBackendServiceProvider.createObject<Task>(
              data: task,
              toJson: taskToJson,
              resourcePath: "tasks.json",
            );

            setState(() {
              // update der Liste
            });
          },
          child: Text("add"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //_buildHeader(),
              SizedBox(
                height: 16,
              ),
              Obx(
                () {
                  int change = _controller.somethingChanged.value;
                  return FutureBuilder<bool>(
                  future: _loadUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildListView(snapshot);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return CircularProgressIndicator();
                  },
                );
                },
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          tasks = [];
        });
      },
      child: Text("clear"),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildListView(AsyncSnapshot<bool> snapshot) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final user = tasks[index];
            return _buildCard(user);
          },
        ),
      ),
    );
  }

  Widget _buildCard(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
      child: Stack(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 162, 219, 156),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text("${task.title} ${task.category}"),
              ),
            ),
          ),
          Container(
            height: 70,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool result = await service.deleteTaskById(id: task.id);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete_outline_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MigraeneanfallEditScreen(id: task.id),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
