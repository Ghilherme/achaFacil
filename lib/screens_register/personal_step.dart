import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/image_picker.dart';
import 'package:AchaFacil/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfessionalStep extends StatefulWidget {
  final ContactsModel contact;
  const ProfessionalStep({Key key, this.contact}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ProfessionalStepState();
  }
}

class ProfessionalStepState extends State<ProfessionalStep> {
  static final formKey = GlobalKey<FormState>();

  ContactsModel _contactModel;

  initState() {
    super.initState();
    _contactModel = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Center(
            child: ImagePickerSource(
              image: _contactModel.imageAvatar,
              callback: callbackAvatar,
              isAvatar: true,
              imageQuality: 35,
            ),
          ),
          Container(height: 30),
          ListTile(
            leading: const Icon(Icons.person),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              initialValue: _contactModel.name,
              onChanged: (value) {
                _contactModel.name = value;
              },
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Nome',
                  hintText: 'Seu nome ou da sua empresa'),
              validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
              leading: const Icon(Icons.phone),
              contentPadding: EdgeInsets.all(0),
              title: TextFormField(
                initialValue: _contactModel.telNumbers['whatsapp'] == null
                    ? ''
                    : _contactModel.telNumbers['whatsapp'],
                onChanged: (value) {
                  _contactModel.telNumbers = {'whatsapp': value.trim()};
                },
                keyboardType: TextInputType.phone,
                maxLines: 1,
                maxLength: 17,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Whatsapp',
                    hintText: '+55 (DDD) + 9 dígitos'),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              )),
          Container(height: kDefaultPadding),
          ListTile(
              leading: const Icon(Icons.email),
              contentPadding: EdgeInsets.all(0),
              title: TextFormField(
                  initialValue: _contactModel.email,
                  onChanged: (value) {
                    _contactModel.email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Email',
                      hintText: 'Ex: achafacil@gmail.com'),
                  validator: (value) {
                    return value.isEmpty
                        ? 'Campo obrigatório'
                        : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)
                            ? null
                            : 'Email inválido';
                  })),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(
              MdiIcons.instagram,
            ),
            contentPadding: EdgeInsets.all(0),
            title: TextFormField(
              initialValue: _contactModel.instagram,
              inputFormatters: [
                FilteringTextInputFormatter.deny('@'),
              ],
              onChanged: (value) {
                _contactModel.instagram = value.trim();
              },
              keyboardType: TextInputType.url,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Instagram',
                  hintText: "Ex: achafacil",
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.facebook),
            contentPadding: EdgeInsets.zero,
            title: TextFormField(
              initialValue: _contactModel.facebook,
              inputFormatters: [
                FilteringTextInputFormatter.deny('@'),
              ],
              onChanged: (value) {
                _contactModel.facebook = value;
              },
              keyboardType: TextInputType.url,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Facebook',
                  hintText: "Ex: achafacil",
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.linkedin),
            contentPadding: EdgeInsets.zero,
            title: TextFormField(
              initialValue: _contactModel.linkedin,
              inputFormatters: [
                FilteringTextInputFormatter.deny('@'),
              ],
              onChanged: (value) {
                _contactModel.linkedin = value;
              },
              keyboardType: TextInputType.url,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Linkedin',
                  hintText: "Ex: achafacil",
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
            leading: const Icon(MdiIcons.web),
            contentPadding: EdgeInsets.zero,
            title: TextFormField(
              initialValue: _contactModel.site,
              inputFormatters: [
                FilteringTextInputFormatter.deny('@'),
              ],
              onChanged: (value) {
                _contactModel.site = value;
              },
              keyboardType: TextInputType.url,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Site',
                  hintText: "Ex: www.achafacil.com.br",
                  helperText: 'Opcional'),
            ),
          ),
          Container(height: kDefaultPadding),
          ListTile(
              leading: const Icon(Icons.picture_in_picture),
              contentPadding: EdgeInsets.zero,
              title: ImagePickerSource(
                image: _contactModel.image,
                callback: callbackImage,
                imageQuality: 40,
              )),
          Container(height: kDefaultPadding),
        ],
      ),
    ));
  }

  callbackImage(file) {
    setState(() {
      _contactModel.image = file;
    });
  }

  callbackAvatar(file) {
    setState(() {
      _contactModel.imageAvatar = file;
    });
  }
}
