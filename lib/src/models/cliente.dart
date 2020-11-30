class Client {
  String nit,
      nombre,
      cliente,
      despliegue,
      fechaCreacion,
      usuarioCreacion,
      fechaModificacion,
      usuarioModificacion;
  Client(
      this.nit,
      this.nombre,
      this.cliente,
      this.despliegue,
      this.fechaCreacion,
      this.usuarioCreacion,
      this.fechaModificacion,
      this.usuarioModificacion);

  Client.fromJson(Map<String, dynamic> json)
      : nit = json["nit"],
        nombre = json["nombre"],
        cliente = json["cliente"].toString(),
        despliegue = json["despliegue"],
        fechaCreacion = json["fecha_creacion"],
        usuarioCreacion = json["fecha_creacion"],
        fechaModificacion = json["fecha_modificacion"],
        usuarioModificacion = json["usuario_modificacion"];
}