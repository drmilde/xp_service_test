import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../services/model/task.dart';
import '../../services/xp_service.dart';
import '../../services/model/object_not_found_exception.dart';

class MigraeneanfallEditScreen extends StatelessWidget {
  int id;
  late XPService service;
  late Task task;

  final _formKey = GlobalKey<FormBuilderState>();

  MigraeneanfallEditScreen({required this.id, Key? key}) : super(key: key) {
    service = XPService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FutureBuilder<bool>(
                future: _loadUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!) {
                      // nutzer mit id wurde gefunden
                      return _buildForm(context, snapshot);
                    } else {
                      // nutzer mit id existiert nicht
                      return Container(
                        child: Text("error loading nutzer"),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            //_buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return FormBuilder(
      key: _formKey,
      // enabled: false,
      onChanged: () {
        _formKey.currentState!.save();
      },
      autovalidateMode: AutovalidateMode.disabled,
      skipDisabled: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            _buildFormTextField(
              name: 'titel',
              labelText: 'Titel',
              value: task.title,
              width: 400,
            ),
            const SizedBox(height: 16),
            _buildFormTextField(
              name: 'category',
              labelText: 'Kategorie',
              value: task.category,
              width: 400,
            ),
            const SizedBox(height: 16),
            _SubmitButton(
                text: "Speichern",
                callback: () async {
                  Task data = Task(
                    title: _formKey.currentState!.value['titel'],
                    category: _formKey.currentState!.value['category'],
                    rewardTickets: task.rewardTickets,
                    rewardCoins: task.rewardCoins,
                    hasRewardXp: task.hasRewardXp,
                    id: task.id,
                  );

                  bool result =
                      await service.updateTaskById(id: task.id, data: data);

                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }

  Widget _SubmitButton(
      {String text = "Submit", required VoidCallback callback}) {
    return ElevatedButton(
      onPressed: () {
        //debugPrint(_formKey.currentState?.value.toString());
        if (_formKey.currentState?.saveAndValidate() ?? false) {
          // TODO update implementieren
          callback();
        } else {
          // TODO handle Form error
          debugPrint('Validierung fehlgeschlagen!');
        }
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildFormTextField({
    required String name,
    required String labelText,
    required String value,
    double width = 250,
  }) {
    return Container(
      width: width,
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.disabled,
        name: name,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: _circularIconButton(name),
        ),
        onChanged: (val) {
// do something sensible here
        },
        initialValue: value,
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        // initialValue: '12',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _circularIconButton(String fieldName) {
    return IconButton(
      onPressed: () {
        print("reset ${fieldName}");
        print(_formKey.currentState!.fields[fieldName]!.value);
        _formKey.currentState!.fields[fieldName]!.didChange("");
      },
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: Icon(
          size: 16,
          Icons.clear,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFormNumberField(
      {required String name, required String labelText}) {
    return Container(
      width: 250,
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.disabled,
        name: name,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: _circularIconButton(name),
        ),
        onChanged: (val) {
// do something sensible here
        },
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
        ]),
        // initialValue: '12',
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Future<bool> _loadUser() async {
    try {
      task = await service.getTaskById(id: this.id);
      return true;
    } on ObjectNotFoundException catch (e) {
      task = Task.empty();
      return false;
    }
    return false;
  }
}
