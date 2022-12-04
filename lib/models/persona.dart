class PersonaModel {
  String nombre;
  String apellido;
  int cedula;
  int mesa;
  int orden;
  String depart;
  String distrito;
  String zona;
  String local;

  PersonaModel(
      {required this.nombre,
        required this.apellido,
        required this.cedula,
        required this.mesa,
        required this.orden,
        required this.depart,
        required this.distrito,
        required this.zona,
        required this.local});

  factory PersonaModel.fromJson(Map<String, dynamic> json) =>PersonaModel(
    nombre: json['nombre'],
    apellido: json['apellido'],
    cedula: json['cedula'],
    mesa: json['mesa'],
    orden: json['orden'],
    depart: json['depart'],
    distrito: json['distrito'],
    zona: json['zona'],
    local: json['local']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['cedula'] = this.cedula;
    data['mesa'] = this.mesa;
    data['orden'] = this.orden;
    data['depart'] = this.depart;
    data['distrito'] = this.distrito;
    data['zona'] = this.zona;
    data['local'] = this.local;
    return data;
  }
}