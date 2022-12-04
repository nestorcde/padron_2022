import 'package:flutter/material.dart';
import 'package:padron_2022/bloc/persona_bloc.dart';
import 'package:padron_2022/models/persona.dart';
import 'package:padron_2022/pages/detalle_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    
    
    return MaterialApp(
      title: 'Padron App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'detalle' : (_) => const DetallePage()
      },
      home: MyHomePage(title: 'Padron Nacional'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.title});
  final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
  final personaBloc = PersonaBloc();
  final cedulaCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints.tight(size),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo1.jpg"),
                fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _crearInput(),
                SizedBox( height: 30,),
                ElevatedButton(
                    child: Text('Consultar'),
                    //color: Colors.blue,
                    onPressed: (){
                        final cedula = int.parse(cedulaCtrl.text.isEmpty?'0':cedulaCtrl.text);
                        cedulaCtrl.text = '';
                        return _mostrarAlerta(context, cedula);
                      },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60), 
                      primary: Color.fromRGBO(0, 42, 92, 100),
                      textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                    ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _crearInput() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: cedulaCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Ej. 1234567',
        labelText: 'Cédula',
        icon: Icon(Icons.fact_check_rounded)
      )

    );
  }

  _mostrarAlerta(BuildContext context, int cedula) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context2){
        personaBloc.obtenerPersona(cedula);
        return StreamBuilder<List<PersonaModel>?>(
          stream: personaBloc.personaStream,
          builder: (context, AsyncSnapshot<List<PersonaModel>?> snapshot) {
            if(snapshot.hasData){
              List<PersonaModel>? data = snapshot.data;
              if(data != null ){
                //cedulaCtrl.text = '';
                return DetallePage(persona: data![0]);
              }else{
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  title: Text('No se encontraron coincidencias'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Verifique que el numero de cedula es ingresado correctamente'),
                    ],
                  ),

                  actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: ()=>Navigator.of(context).pop(),
                      )
                  ],
                );
              }

            } else{
              return Center(child: CircularProgressIndicator());
            }
          }
        );
      }
    );
  }
}
