class TypeProduct {
  String activo,
      despliegue,
      bienServicio,
      tipoProducto,
      fechaCreacion,
      usuarioCreacion,
      activoDescripcion,
      fechaModificacion,
      usuarioModificacion,
      bienServicioDescripcion,
      tipoProductoDescripcion;
  TypeProduct(
      this.activo,
      this.despliegue,
      this.bienServicio,
      this.tipoProducto,
      this.fechaCreacion,
      this.usuarioCreacion,
      this.activoDescripcion,
      this.fechaModificacion,
      this.usuarioModificacion,
      this.bienServicioDescripcion,
      this.tipoProductoDescripcion);

  TypeProduct.fromJson(Map<String, dynamic> json)
      : activo = json["activo"].toString(),
      despliegue = json["despliegue"].toString(),
      bienServicio = json["bien_servicio"].toString(),
      tipoProducto = json["tipo_producto"].toString(),
      fechaCreacion = json["fecha_creacion"].toString(),
      usuarioCreacion = json["usuario_creacion"].toString(),
      activoDescripcion = json["activo_descripcion"].toString(),
      fechaModificacion = json["fecha_modificacion"].toString(),
      usuarioModificacion = json["usuario_modificacion"].toString(),
      bienServicioDescripcion = json["bien_servicio_descripcion"].toString(),
      tipoProductoDescripcion = json["tipo_producto_descripcion"].toString()

      ;
}
