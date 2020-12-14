class DetailInvoice {
  String cantidad,
      producto,
      valorUnitario,
      descuentoUnitario,
      descripcion,
      identificador,
      tipoProducto,
      bienServicio;
  DetailInvoice(
      this.cantidad,
      this.producto,
      this.valorUnitario,
      this.descuentoUnitario,
      this.descripcion,
      this.identificador,
      this.tipoProducto,
      this.bienServicio);

  DetailInvoice.fromJson(Map<String, dynamic> json)
      : cantidad = json["cantidad"].toString(),
      producto = json["producto"].toString(),
      valorUnitario = json["valorUnitario"].toString(),
      descuentoUnitario = json["descuentoUnitario"].toString(),
      descripcion = json["descripcion"].toString(),
      identificador = json["descripcion"].toString(),
      tipoProducto = json["descripcion"].toString()
      ;

  Map<String, dynamic> toJson()=>{
    'cantidad': cantidad,
    'producto' : producto,
    'valorUnitario' : valorUnitario,
    'descuentoUnitario' : descuentoUnitario,
    'descripcion':descripcion
  };
}
