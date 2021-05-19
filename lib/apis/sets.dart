import 'package:AchaFacil/models/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sets {
  static Future<void> setPeople(
      ContactsModel contact, DocumentReference refDB) {
    return refDB.set({
      'nome': contact.name,
      'email': contact.email,
      'descricao': contact.description,
      'servicos': contact.serviceType,
      'site': contact.site,
      'telefone1': contact.telNumbers,
      'imagem': contact.image,
      'avatar': contact.imageAvatar,
      'horarios': contact.timeTable,
      'funcionamento': contact.scheduleType,
      'atualizacao': contact.lastModification,
      'criacao': contact.createdAt,
      'instagram': contact.instagram,
      'facebook': contact.facebook,
      'linkedin': contact.linkedin,
      'status': contact.status,
      'radarkms': contact.regionAttendanceRadar,
      'endereco': {
        'endereco': contact.address.strAvnName,
        'complemento': contact.address.compliment,
        'numero': contact.address.number,
        'bairro': contact.address.neighborhood,
        'cidade': contact.address.city,
        'estado': contact.address.state,
        'UF': contact.address.uf,
        'coordenadas': contact.address.coordinates,
      },
      'avaliacao': {
        'atendimento': contact.rating.attendance,
        'geral': contact.rating.general,
        'preco': contact.rating.price,
        'qualidade': contact.rating.quality,
        'quantidade': contact.rating.number,
      }
    });
  }
}
