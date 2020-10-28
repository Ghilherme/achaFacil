class ServiceType {
  final String serviceName, categorieName;
  final int id;

  // ignore: sort_constructors_first
  ServiceType({this.serviceName, this.id, this.categorieName});
}

List<ServiceType> services = [
  ServiceType(
    id: 1,
    serviceName: 'Encanadores',
    categorieName: 'Reformas e Reparos',
  ),
  ServiceType(
    id: 2,
    serviceName: 'Pintores',
    categorieName: 'Reformas e Reparos',
  ),
  ServiceType(
    id: 3,
    serviceName: 'Eletricistas',
    categorieName: 'Reformas e Reparos',
  ),
  ServiceType(
    id: 4,
    serviceName: 'Vidraceiros',
    categorieName: 'Reformas e Reparos',
  ),
  ServiceType(
    id: 5,
    serviceName: 'Arquitetos',
    categorieName: 'Construção',
  ),
  ServiceType(
    id: 6,
    serviceName: 'Engenheiros',
    categorieName: 'Construção',
  ),
  ServiceType(
    id: 7,
    serviceName: 'Pedreiros',
    categorieName: 'Construção',
  ),
  ServiceType(
    id: 8,
    serviceName: 'Limpeza pós obra',
    categorieName: 'Construção',
  ),
  ServiceType(
    id: 9,
    serviceName: 'Chaveiro',
    categorieName: 'Serviços Gerais',
  ),
  ServiceType(
    id: 10,
    serviceName: 'Dedetizador',
    categorieName: 'Serviços Gerais',
  ),
  ServiceType(
    id: 11,
    serviceName: 'Desentupidor',
    categorieName: 'Serviços Gerais',
  ),
  ServiceType(
    id: 12,
    serviceName: 'Marido de aluguel',
    categorieName: 'Serviços Gerais',
  ),
  ServiceType(
    id: 13,
    serviceName: 'Antenista',
    categorieName: 'Instalação',
  ),
  ServiceType(
    id: 14,
    serviceName: 'Instação de eletrônicos',
    categorieName: 'Instalação',
  ),
  ServiceType(
    id: 15,
    serviceName: 'Instalador TV Digital',
    categorieName: 'Instalação',
  ),
  ServiceType(
    id: 16,
    serviceName: 'Vidraceiros',
    categorieName: 'Instalação',
  ),
];
