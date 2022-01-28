// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unused_field

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String cadenaOperaciones = "";
  String resultado = "0";
  double total = 0;
  String operacion = "";
  int indiceOperacion = 0;
  bool pulsadoIgual = false;
  Color? azulClaro = Colors.blue[50];
  Color? naranja = Colors.orange[700];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        
        children: [
          cajaTextoOperaciones(),
          cajaTextoResultado(),
          Padding(padding: const EdgeInsets.all(10.0) ),
          Expanded(
            flex: 3,
            child: GridView.count(
              //childAspectRatio: 1.3, 
              crossAxisCount: 4,
              children: [
                  boton("C", azulClaro!, Colors.black),
                  boton("+/-", azulClaro!, Colors.black),
                  boton("%", azulClaro!, Colors.black),
                  boton("DEL", azulClaro!, Colors.black),
                  boton("7", Colors.white, Colors.black),
                  boton("8", Colors.white, Colors.black),
                  boton("9", Colors.white, Colors.black),
                  boton("/", Colors.blueAccent, Colors.white),
                  boton("4", Colors.white, Colors.black),
                  boton("5", Colors.white, Colors.black),
                  boton("6", Colors.white, Colors.black),
                  boton("x", Colors.blueAccent, Colors.white),
                  boton("1", Colors.white, Colors.black),
                  boton("2", Colors.white, Colors.black),
                  boton("3", Colors.white, Colors.black),
                  boton("-", Colors.blueAccent, Colors.white),
                  boton("0", Colors.white, Colors.black),
                  boton(".", Colors.white, Colors.black),
                  boton("=", naranja!, Colors.white),
                  boton("+", Colors.blueAccent, Colors.white)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget cajaTextoOperaciones() {
    return Container(  
          width: MediaQuery.of(context).size.width,
          height: 100,
          alignment: Alignment.centerRight,
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$cadenaOperaciones",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'RobotoMono',
              ),),
            )   
        );
  }

  Widget cajaTextoResultado() {
    return Container(  
          width: MediaQuery.of(context).size.width,
          height: 100,
          alignment: Alignment.centerRight,
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$resultado",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'RobotoMono',
              ),),
            )   
        );
  }

  Widget boton(String texto, Color fondo, Color letra) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
      style: ElevatedButton.styleFrom(   
        primary: fondo,
        onPrimary: letra,
        textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
      )
          ),
      onPressed: () {
        setState(() {
          if(pulsadoIgual){
            borrar();
            pulsadoIgual = false;
          }

          if(texto == "C"){
            borrar();
          }else if(texto == "+/-"){
            resultado = (double.parse(resultado)*-1).toString();
            resultado = resultado.endsWith('.0') ? resultado.split('.')[0] : resultado;
          }else if(esOperador(texto)){
            if(indiceOperacion == 0 && texto != "="){
              indiceOperacion = 1;
              operacion = texto;
              if(esNumerico(resultado)){
                total = double.parse(resultado);
                if(double.parse(resultado) < 0){
                  cadenaOperaciones += "(" + resultado + ")" + texto;
                  }else{
                    cadenaOperaciones += resultado + texto;
                  }
                  resultado = "0";
              }else{
                borrar();
                resultado = "Error";
              }
              
            }else{
              total = calcular(operacion);
              if(texto == "="){
                pulsadoIgual = true;
                indiceOperacion = 0;
                if(esNumerico(resultado)){
                  if(double.parse(resultado) < 0){
                  cadenaOperaciones += "(" + resultado + ")" ;
                  }else{
                    cadenaOperaciones += resultado ;
                  }
                  resultado = total.toString();
                  resultado = resultado.endsWith('.0') ? resultado.split('.')[0] : resultado;
                  operacion = texto;
                }else{
                  borrar();
                  resultado = "Error";
                }
              }else{
                if(esNumerico(resultado)){
                  if(double.parse(resultado) < 0){
                    cadenaOperaciones += "(" + resultado + ")" + texto;
                  }else{
                    cadenaOperaciones += resultado + texto;
                  }
                  resultado = "0";
                  operacion = texto;
                }else{
                  borrar();
                  resultado = "Error";
                }
              }
            }
          }else if(texto == "DEL"){
            borrarUltimoDigito();
          }else{
            anadirDigito(texto);
          }
        });
      }, 
      child: 
      Text(texto)),
    );
  }

  bool esOperador(String dato){
    if(dato == "x" || dato == "/" || dato == "+" || dato == "-" || dato == "=" || dato == "%") {
      return true;
    }
    return false;
  }

  String anadirDigito(String digito){
    if(resultado == "0" && digito != "."){
      resultado = "";
    }else if( resultado == "-0" && digito != "."){
      resultado = "-";
    }else if(digito == "." && resultado.contains(".")){
      digito = "";
    }
    return resultado += digito;
  }

  void borrarUltimoDigito() {
    resultado = resultado.length > 1 ? resultado.substring(0, resultado.length - 1) : '0';
  }

  void borrar(){
    resultado = "0";
    indiceOperacion = 0;
    cadenaOperaciones = "";
    total = 0;
  }

  double calcular(String operacion){
    double calculo = 0;
    try{
      switch(operacion){
      case "/":
        calculo = total / double.parse(resultado);
        break;
      case "x":
        calculo = total * double.parse(resultado);
        break;
      case "+":
        calculo = total + double.parse(resultado);
        break;
      case "-":
        calculo= total - double.parse(resultado);
        break;
      case "%":
        calculo = total % double.parse(resultado);
        break;
      case "=":
        calculo = total + double.parse(resultado);
        break;
      }
    }catch(e){
      calculo = -1;
    }
    
    return calculo;
  }
}

bool esNumerico(String numero){
  try{
    double.parse(numero);
  }catch(e){
    return false;
  }
  return true;
}

  