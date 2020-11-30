class Invoice {
  String asociado,
      despliegue,
      documentoTipo,
      fechaCreacion,
      usuarioCreacion,
      fechaModificacion,
      usuarioModificacion,
      documentoTipoDescripcion;
  Invoice(
      this.asociado,
      this.despliegue,
      this.documentoTipo,
      this.fechaCreacion,
      this.usuarioCreacion,
      this.fechaModificacion,
      this.usuarioModificacion,
      this.documentoTipoDescripcion);

  Invoice.fromJson(Map<String, dynamic> json)
      : asociado = json["asociado"].toString(),
      despliegue = json["despliegue"].toString(),
      documentoTipo = json["documento_tipo"].toString(),
      fechaCreacion = json["fecha_creacion"].toString(),
      usuarioCreacion = json["usuario_creacion"].toString(),
      fechaModificacion = json["fecha_modificacion"].toString(),
      usuarioModificacion = json["usuario_modificacion"].toString(),
      documentoTipoDescripcion = json["documento_tipo_descripcion"].toString()
      ;
}
