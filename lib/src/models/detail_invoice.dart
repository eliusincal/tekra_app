class DetailInvoice {
  String cantidad,
      producto,
      valorUnitario,
      descuentoUnitario,
      descripcion;
  DetailInvoice(
      this.cantidad,
      this.producto,
      this.valorUnitario,
      this.descuentoUnitario,
      this.descripcion);

  DetailInvoice.fromJson(Map<String, dynamic> json)
      : cantidad = json["cantidad"].toString(),
      producto = json["producto"].toString(),
      valorUnitario = json["valorUnitario"].toString(),
      descuentoUnitario = json["descuentoUnitario"].toString(),
      descripcion = json["descripcion"].toString()
      ;

  Map<String, dynamic> toJson()=>{
    'cantidad': cantidad,
    'producto' : producto,
    'valorUnitario' : valorUnitario,
    'descuentoUnitario' : descuentoUnitario,
    'descripcion':descripcion
  };
}
