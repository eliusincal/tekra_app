class Coin {
  String moneda,
      nombreMoneda;

  Coin(
      this.moneda,
      this.nombreMoneda);

  Coin.fromJson(Map<String, dynamic> json)
      : moneda = json["moneda"].toString(),
      nombreMoneda = json["moneda_nombre"].toString()
      ;
}
