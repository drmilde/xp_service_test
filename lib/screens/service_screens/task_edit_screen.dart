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

  void _onChanged(dynamic val) => debugPrint(val.toString());
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
                    if (snapshot.data!) { // nutzer mit id wurde gefunden
                      return _buildForm(snapshot);
                    } else { // nutzer mit id existiert nicht
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

  Widget _buildForm(AsyncSnapshot<bool> snapshot) {
    return FormBuilder(
      key: _formKey,
      // enabled: false,
      onChanged: () {
        _formKey.currentState!.save();
        debugPrint(_formKey.currentState!.value.toString());
      },
      autovalidateMode: AutovalidateMode.disabled,
      skipDisabled: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            _buildFormTextField(
              name: 'titel',
              labelText: 'Titel',
              value: task.title,
            ),
            const SizedBox(height: 15),
            _buildFormTextField(
              name: 'category',
              labelText: 'Kategorie',
              value: task.category,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTextField({
    required String name,
    required String labelText,
    required String value,
  }) {
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
          suffixIcon: _circularIconButton(),
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

  Widget _circularIconButton() {
    return IconButton(
      onPressed: () {},
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
          suffixIcon: _circularIconButton(),
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
