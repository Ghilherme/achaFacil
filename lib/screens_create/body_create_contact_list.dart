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
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateContact(
                      contact: Contacts.empty(),
                    )));
          },
        ),
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
                  return _buildRow(context, querySnapshot.docs[i].data(), i,
                      querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> snapshot,
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
                              name: snapshot['nome'],
                              description: snapshot['descricao'],
                              email: snapshot['email'],
                              telNumbers: {
                                'whatsapp': snapshot['telefone1']['whatsapp']
                              },
                              serviceType: snapshot['servicos'],
                              address: Address(
                                  strAvnName: snapshot['endereco']['endereco'],
                                  cep: snapshot['endereco']['cep'],
                                  city: snapshot['endereco']['cidade'],
                                  compliment: snapshot['endereco']
                                      ['complemento'],
                                  country: snapshot['endereco']['pais'],
                                  neighborhood: snapshot['endereco']['bairro'],
                                  number: snapshot['endereco']['numero'],
                                  state: snapshot['endereco']['estado'],
                                  uf: snapshot['endereco']['UF'])))));
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
          snapshot['nome'],
        ),
        subtitle: snapshot['endereco']['UF'] == null
            ? Text('')
            : Text(snapshot['endereco']['cidade'] +
                ' ' +
                snapshot['endereco']['UF']),
      ),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
