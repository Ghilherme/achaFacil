import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/timetable_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../constants.dart';

class AttendanceStep extends StatefulWidget {
  final ContactsModel contact;

  const AttendanceStep({Key key, this.contact}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AttendanceStepState();
  }
}

class AttendanceStepState extends State<AttendanceStep> {
  static final formKey = GlobalKey<FormState>();

  List<MultiSelectItem> _items = List<MultiSelectItem>();
  ContactsModel _contactModel;
  String _dropdownSchedule;

  initState() {
    super.initState();
    getServiceTypes();
    _contactModel = widget.contact;
    if (_contactModel.scheduleType.first.isNotEmpty) {
      _dropdownSchedule = schedule
          .where((element) => element == _contactModel.scheduleType.first)
          .first;
    }
  }

  Future<void> getServiceTypes() async {
    //Pega a tabela categorias somente da categoria selecionada
    List<String> prestadores = new List<String>();
    await FirebaseFirestore.instance
        .collection('prestadores')
        .orderBy('nome')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return prestadores.add(element.data()['nome']);
      });
    });
    if (this.mounted) {
      setState(() {
        _items = prestadores
            .map((prestador) => MultiSelectItem<String>(prestador, prestador))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.description,
              onChanged: (value) {
                _contactModel.description = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                labelText: 'Descrição',
                alignLabelWithHint: true,
                hintText: 'Descrição dos seus serviços',
              ),
            ),
          ),
          Container(height: 30),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Icons.list),
            title: MultiSelectDialogField(
                initialValue: _contactModel.serviceType,
                searchable: true,
                items: _items.isEmpty
                    ? _contactModel.serviceType
                        .map((prestador) =>
                            MultiSelectItem<String>(prestador, prestador))
                        .toList()
                    : _items,
                title: Text('Prestadores'),
                buttonText: Text('Ofereço serviços como:',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                onConfirm: (results) => _contactModel.serviceType = results,
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obrigatório'
                    : null),
          ),
          Container(height: 30),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Icons.schedule),
            title: DropdownButtonFormField<String>(
                isExpanded: true,
                hint: Text('Funcionamento'),
                value: _dropdownSchedule,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  _contactModel.scheduleType.first = newValue;
                  setState(() {
                    _dropdownSchedule = newValue;
                  });
                },
                items: schedule.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obrigatório'
                    : null),
          ),
          Container(height: 30),
          ListTile(
              leading: Icon(MdiIcons.timetable),
              contentPadding: EdgeInsets.all(0),
              title: RaisedButton.icon(
                icon: Icon(Icons.add),
                onPressed: openDialogSchedule,
                label: Text('Horário de Funcionamento'),
              )),
          Container(height: 30),
        ],
      ),
    );
  }

  openDialogSchedule() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Revise os horários em que pode atender. (Opcional)'),
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: TimeTableAdmin(
                timeTable: _contactModel.timeTable,
                callback: callbackTimeTable,
                preFillTimeTable: _contactModel.timeTable.isEmpty
                    ? _contactModel.scheduleType.first
                    : null,
              ),
            ),
            Center(
                child: ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }))
          ],
          contentPadding: const EdgeInsets.all(kDefaultPadding),
        );
      },
    );
  }

  callbackTimeTable(timeTable) {
    setState(() {
      _contactModel.timeTable = timeTable;
    });
  }
}
