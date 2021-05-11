import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class RegionStep extends StatefulWidget {
  final ContactsModel contact;

  const RegionStep({Key key, this.contact}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegionStepState();
  }
}

class RegionStepState extends State<RegionStep> {
  static final formKey = GlobalKey<FormState>();
  States _dropdownStates = statesList[24]; //SAO PAULO
  ContactsModel _contactModel;
  initState() {
    super.initState();
    _contactModel = widget.contact;

    if (_contactModel.address.state.isNotEmpty) {
      _dropdownStates = statesList
          .where((element) => element.state == _contactModel.address.state)
          .first;
    }
    _contactModel.address.uf = _dropdownStates.uf;
    _contactModel.address.state = _dropdownStates.state;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.business),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.address.strAvnName,
              onChanged: (value) {
                _contactModel.address.strAvnName = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                labelText: 'Endereço',
                hintText: 'Rua/Avenida',
              ),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(Icons.add_road),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.address.compliment,
              onChanged: (value) {
                _contactModel.address.compliment = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Complemento',
                  hintText: 'Ex: apto 500, bl 2',
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.signRealEstate),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.address.number,
              onChanged: (value) {
                _contactModel.address.number = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Número',
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.homeCity),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.address.neighborhood,
              onChanged: (value) {
                _contactModel.address.neighborhood = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                labelText: 'Bairro',
              ),
              validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.cityVariant),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.address.city,
              onChanged: (value) {
                _contactModel.address.city = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Cidade',
                  hintText: 'Ex: Dracena'),
              validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(Icons.map),
            contentPadding: EdgeInsets.all(0),
            title: DropdownButton<States>(
              isExpanded: true,
              hint: Text('Estado'),
              value: _dropdownStates,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (States newValue) {
                _contactModel.address.uf = newValue.uf;
                _contactModel.address.state = newValue.state;
                setState(() {
                  _dropdownStates = newValue;
                });
              },
              items: statesList.map<DropdownMenuItem<States>>((States value) {
                return DropdownMenuItem<States>(
                  value: value,
                  child: Text(value.state),
                );
              }).toList(),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.radar),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              onChanged: (value) {
                _contactModel.regionAttendanceRadar = int.parse(value);
              },
              keyboardType: TextInputType.number,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Atende em até',
                  hintText: 'Ex: 80 kms',
                  helperText: 'Opcional'),
            ),
          ),
        ],
      ),
    ));
  }
}
