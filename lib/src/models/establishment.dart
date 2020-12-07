class Establishment {
  String nombre,
      despliegue,
      establecimiento
      ;

  Establishment(
      this.nombre,
      this.despliegue,
      this.establecimiento);

  Establishment.fromJson(Map<String, dynamic> json)
      : nombre = json["nombre"].toString(),
      despliegue = json["despliegue"].toString(),
      establecimiento = json["establecimiento"].toString()
      ;
}
