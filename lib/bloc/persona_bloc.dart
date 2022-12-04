
import 'dart:async';

import 'package:padron_2022/models/persona.dart';
import 'package:padron_2022/providers/db_providers.dart';

class PersonaBloc {
  


  static final PersonaBloc _singleton = new PersonaBloc._internal();
  
  factory PersonaBloc()=>_singleton;

  PersonaBloc._internal();

  final _personaController = StreamController<List<PersonaModel>?>.broadcast();

  Stream<List<PersonaModel>?> get personaStream     => _personaController.stream;

  void dispose() { 
    _personaController?.close();
  }


  obtenerPersona(int cedula) async{
    _personaController.sink.add(await DBProvider.db.getPerPorCed(cedula));
  }


}