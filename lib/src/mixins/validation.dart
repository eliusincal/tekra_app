class ValidationMixins{
  String validateUsuario(String value){
    if(value.isEmpty){
      return "Complete este campo";
    }
    return null;
  }

  String validateContrasena(String value){
    if(value.isEmpty){
      return "Complete este campo";
    }
    if(value.length < 6){
      return "Contraseña menor a 6 caractéres";
    }
    return null;
  }

  String validateCode(String value){
    if(value.isEmpty){
      return "Complete este campo";
    }
    return null;
  }
}