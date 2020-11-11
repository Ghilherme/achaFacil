import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/contacts.dart';
import 'create_contact.dart';

class BodyCreateContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Pega a tabela contatos somente dos prestadores cadastrados com x categoria
    Query query = FirebaseFirestore.instance.collection('contatos');

    return Scaffold(
        appBar: AppBar(
            title: Text('Lista de contatos'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Show Snackbar',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateContact(
                              contact: Contacts.empty(),
                            )));
                  })
            ],
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, stream) {
            //Trata Load
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            //Trata Erro
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
                padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                itemCount: querySnapshot.size,
                itemBuilder: (context, i) {
                  return _buildRow(
                      context, querySnapshot.docs[i], i, querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, QueryDocumentSnapshot snapshot,
      int indice, int size) {
    return Column(children: <Widget>[
      ListTile(
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateContact(
                          contact: Contacts(
                              id: snapshot.id,
                              name: snapshot.data()['nome'],
                              description: snapshot.data()['descricao'],
                              email: snapshot.data()['email'],
                              site: snapshot.data()['site'],
                              telNumbers: {
                                'whatsapp': snapshot.data()['telefone1']
                                    ['whatsapp']
                              },
                              serviceType: snapshot.data()['servicos'],
                              address: Address(
                                  strAvnName: snapshot.data()['endereco']
                                      ['endereco'],
                                  cep: snapshot.data()['endereco']['cep'],
                                  city: snapshot.data()['endereco']['cidade'],
                                  compliment: snapshot.data()['endereco']
                                      ['complemento'],
                                  country: snapshot.data()['endereco']['pais'],
                                  neighborhood: snapshot.data()['endereco']
                                      ['bairro'],
                                  number: snapshot.data()['endereco']['numero'],
                                  state: snapshot.data()['endereco']['estado'],
                                  uf: snapshot.data()['endereco']['UF'])))));
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {},
              ),
            ],
          ),
        ),
        title: Text(
          snapshot.data()['nome'],
        ),
        subtitle: snapshot.data()['endereco']['UF'] == null
            ? Text('')
            : Text(snapshot.data()['endereco']['cidade'] +
                ' ' +
                snapshot.data()['endereco']['UF']),
      ),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
