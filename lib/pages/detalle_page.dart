

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:padron_2022/models/persona.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';



class DetallePage extends StatefulWidget {
  const DetallePage({ this.persona});

  final PersonaModel? persona;

  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  bool isVisible = true;
    final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
  final size = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) ;
    return Screenshot(
      controller: controller,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints.tight(size),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fondo1.jpg"),
                  fit: BoxFit.contain)),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('NOMBRE Y APELLIDO'),
                  Text('${widget.persona?.nombre} ${widget.persona?.apellido}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),textAlign: TextAlign.center,),
                  Text('CEDULA'),
                  Text('${widget.persona?.cedula}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('MESA'),
                  Text('${widget.persona?.mesa}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('ORDEN'),
                  Text('${widget.persona?.orden}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('LOCAL'),
                  Text('${widget.persona?.local}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('ZONA'),
                  Text('${widget.persona?.zona}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('DISTRITO'),
                  Text('${widget.persona?.distrito}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  Text('DEPARTAMENTO'),
                  Text('${widget.persona?.depart}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),textAlign: TextAlign.center,),
                  SizedBox(height: 30,),
                  if(isVisible)
                    ElevatedButton(
                        child: Text('Volver'),
                        onPressed: ()=> Navigator.pop(context) /*push(context, MaterialPageRoute(builder: (context)=>MyHomePage()))*/,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50), 
                          primary: Color.fromRGBO(0, 42, 92, 100),
                          textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                        ),
                    ),
                  SizedBox(height: 10,),
                  if(isVisible)
                    ElevatedButton(
                        
                        child: Text('Compartir'),
                        onPressed: () async {
                          setState(() => isVisible = !isVisible);
                          final image = await controller.capture();
                          if(image == null) return;
                          //await saveImage(image);
                          saveAndShare(image, widget.persona);
                          Navigator.pop(context);
                        } /*push(context, MaterialPageRoute(builder: (context)=>MyHomePage()))*/,
                        style: ElevatedButton.styleFrom(

                          minimumSize: Size(150, 50), 
                          primary: Color.fromRGBO(0, 42, 92, 100),
                          textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                        ),
                    ),
                ],
              ),

            )
          ),
        ),
      ),
    );
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();
  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '_')
  //       .replaceAll(':', '_');
  //   final name = 'padron_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   return result['filePath'];
  // }

  Future saveAndShare(Uint8List bytes, PersonaModel? persona) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/padron.png');
    image.writeAsBytesSync(bytes);

    final text = 'Estimado/a ${persona?.nombre}, para facilitarle su visita al sitio de votación en las elecciones, le remito el local, número de mesa y orden de votación. Lista 1 - Opcion 1';
    await Share.shareFiles([image.path], text: text);
  }
}