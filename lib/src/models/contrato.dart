class Contract {
  String nit,
      cliente,
      asociado,
      finalizado,
      noContrato,
      fechaInicio,
      clavePrivada,
      contratoInfo,
      archivoLlaves,
      nombreCliente,
      usuarioCreacion,
      direccionCliente,
      correlativoContrato,
      fechaFinalizacion;
  Contract(
      this.nit,
      this.cliente,
      this.asociado,
      this.finalizado,
      this.noContrato,
      this.fechaInicio,
      this.clavePrivada,
      this.contratoInfo,
      this.archivoLlaves,
      this.nombreCliente,
      this.usuarioCreacion,
      this.direccionCliente,
      this.correlativoContrato,
      this.fechaFinalizacion);

  Contract.fromJson(Map<String, dynamic> json)
      : nit = json["nit"],
        cliente = json["cliente"].toString(),
        asociado = json["asociado"].toString(),
        finalizado = json["asfinalizadoociado"].toString(),
        noContrato = json["no_contrato"],
        fechaInicio = json["fecha_inicio"],
        clavePrivada = json["clave_privada"],
        contratoInfo = json["contrato_info"],
        archivoLlaves = json["archivo_llaves"],
        nombreCliente = json["nombre_cliente"],
        usuarioCreacion = json["usuario_creacion"],
        direccionCliente = json["direccion_cliente"],
        correlativoContrato = json["correlativo_contrato"].toString(),
        fechaFinalizacion = json["fecha_finalizacion"]
      ;
}
