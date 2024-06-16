import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newton_calculator/operations.dart';
import 'package:newton_calculator/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double angle = 30.0; // Ángulo inicial
  double inputAngle = 30.0;
  double inputMasa1 = 0.00;
  double inputMasa2 = 0.00;
  double inputCoeficienteRozamiento = 0.00;

  double resultadoAceleracion = 0.0;
  double resultadoTension = 0.0;
  double resultadoNormal = 0.0;
  double resultadoPeso1 = 0.0;
  double resultadoPeso2 = 0.0;
  double resultadoFriccion = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo con campos de entrada y botón
          Container(
            width: 300,
            color: Colors.blue.shade900,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GRUPO X',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Masa 1',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputMasa1 = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Masa 2',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputMasa2 = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        inputCoeficienteRozamiento =
                            double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Coeficiente de Fricción',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        inputAngle = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Ángulo',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Calculos calculos = Calculos(inputMasa1, inputMasa2,
                            inputAngle, inputCoeficienteRozamiento);
                        calculos.calculoAceleracion();
                        calculos.calculoTension();
                        setState(() {
                          angle = inputAngle;
                          resultadoAceleracion = calculos.aceleracion;
                          resultadoTension = calculos.tension;
                          resultadoPeso1 = calculos.peso1;
                          resultadoPeso2 = calculos.peso2;
                          resultadoNormal = calculos.normal;
                          resultadoFriccion = calculos.friccion;
                        });
                      },
                      child: Text('Calcular'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Panel derecho con contenedores
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                      height: 50,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Text(
                          'Diagrama de Cuerpo Libre',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          color: Colors.grey.shade300,
                          child: CustomPaint(
                            painter: FreeBodyDiagramPainter(angle: angle),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          height: 400,
                          color: Colors.grey.shade300,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Masa Cuerpo 1 = $inputMasa1 KG',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          'w = ${doubleToThreeDecimals(resultadoPeso1)} m/s²'),
                                    ],
                                  ), //Peso
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          'Fk = ${doubleToThreeDecimals(resultadoFriccion)} N'),
                                    ],
                                  ), //Fuerza Rozamiento
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          'N = ${doubleToThreeDecimals(resultadoNormal)} N'),
                                    ],
                                  ), //Fuerza Normal
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.lightGreen,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Masa Cuerpo 2 = $inputMasa2 kg',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.purple,
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text('w = $resultadoPeso2 m/s²'),
                                    ],
                                  ), //Peso
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.blueGrey.shade900,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              color: Colors.lightGreen,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'a = ${doubleToThreeDecimals(resultadoAceleracion)} m/s²',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                              ),
                                              width: 10,
                                              height: 10,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                                'T = ${doubleToThreeDecimals(resultadoTension)} N',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ), //Tension
                                      ],
                                    ),
                                  ), //Acelearacion
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 50,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Text(
                                'Diagrama 1',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                            height: 50,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Text(
                                'Diagrama 2',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ), //Titulos fila 2
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey.shade300,
                            child: Center(
                              child: CustomPaint(
                                painter: TrianglePainter(angle: angle),
                                child:
                                    Container(), // Puedes omitir el child o poner uno vacío
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                              color: Colors.grey.shade300,
                              child: Center(
                                child: CustomPaint(
                                  painter: SecondDiagramPainter(
                                      arrowColorUp: Colors.purple,
                                      arrowColorDown: Colors.pink),
                                  child:
                                      Container(), // Puedes omitir el child o poner uno vacío
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double angle;

  TrianglePainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double radians = angle * math.pi / 180;
    double length = 200.0; // Longitud inicial de la base del triángulo
    double height =
        length * math.tan(radians); // Altura calculada del triángulo

    // Ajustar el tamaño del triángulo para que no exceda los límites del contenedor
    double scaleFactor = 1.0;
    if (height > size.height * 0.8 || length > size.width * 0.8) {
      scaleFactor = min(size.width * 0.8 / length, size.height * 0.8 / height);
      length *= scaleFactor;
      height *= scaleFactor;
    }

    // Posición centrada del triángulo
    final Offset pointA = Offset((size.width - length) / 2, size.height - 50);
    final Offset pointB = Offset(pointA.dx + length, pointA.dy);
    final Offset pointC = Offset(pointB.dx, pointA.dy - height);

    // Dibujamos el triángulo
    canvas.drawPath(
      Path()
        ..moveTo(pointA.dx, pointA.dy)
        ..lineTo(pointB.dx, pointB.dy)
        ..lineTo(pointC.dx, pointC.dy)
        ..close(),
      paint,
    );

    // Dibujamos la polea
    final pulleyPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    final Offset pulleyCenter = pointC;
    canvas.drawCircle(pulleyCenter, 10, pulleyPaint);

    // Cuerdas y bloques
    final ropePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    final double dropDistance = length *
        0.25; // Distancia proporcional al tamaño ajustado del triángulo
    final Offset weight1 = Offset(
      pulleyCenter.dx - dropDistance * math.cos(radians),
      pulleyCenter.dy + dropDistance * math.sin(radians),
    );
    final Offset weight2 =
        Offset(pulleyCenter.dx, pulleyCenter.dy + dropDistance);

    canvas.drawLine(pulleyCenter, weight1, ropePaint);
    canvas.drawLine(pulleyCenter, weight2, ropePaint);

    // Dibujamos los bloques con rotación
    final blockPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final blockSize = 20.0;

    // Guardar el estado del canvas antes de rotarlo
    canvas.save();

    // Trasladar el canvas al centro del primer bloque
    canvas.translate(weight1.dx, weight1.dy);

    // Rotar el canvas en el ángulo adecuado
    canvas.rotate(-radians);

    // Dibujar el primer bloque en el canvas rotado
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(0, 0), width: blockSize, height: blockSize),
      blockPaint,
    );

    // Restaurar el estado del canvas
    canvas.restore();

    // Guardar el estado del canvas antes de rotarlo
    canvas.save();

    // Trasladar el canvas al centro del segundo bloque
    canvas.translate(weight2.dx, weight2.dy);

    // No rotar el segundo bloque ya que debe estar vertical
    // Dibujar el segundo bloque
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(0, 0), width: blockSize, height: blockSize),
      blockPaint,
    );

    // Restaurar el estado del canvas
    canvas.restore();

    // Dibujar el texto del ángulo
    final textSpan = TextSpan(
      text: '${angle.toStringAsFixed(1)}°',
      style: TextStyle(color: Colors.black, fontSize: 18),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(pointA.dx + 5, pointA.dy - 30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FreeBodyDiagramPainter extends CustomPainter {
  final double angle;

  FreeBodyDiagramPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double radians = angle * math.pi / 180;
    double length = 500.0;
    double height = length * math.tan(radians);

    double scaleFactor = 1.0;
    if (height > size.height * 0.8 || length > size.width * 0.8) {
      scaleFactor = min(size.width * 0.8 / length, size.height * 0.8 / height);
      length *= scaleFactor;
      height *= scaleFactor;
    }

    final Offset pointA =
        Offset((size.width - length) / 2, (size.height + height) / 2);
    final Offset pointB = Offset(pointA.dx + length, pointA.dy);
    final Offset pointC = Offset(pointB.dx, pointB.dy - height);

    // Dibujar el triángulo
    canvas.drawPath(
      Path()
        ..moveTo(pointA.dx, pointA.dy)
        ..lineTo(pointB.dx, pointB.dy)
        ..lineTo(pointC.dx, pointC.dy)
        ..close(),
      paint,
    );

    final blockPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final double blockSize = 40.0;

    final blockPaintSecondary = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.fill;

    // Primer cuadrado
    final Offset blockCenter1 = Offset(
      (pointA.dx + pointC.dx) / 2,
      (pointA.dy + pointC.dy) / 2,
    );

    canvas.save();
    canvas.translate(blockCenter1.dx, blockCenter1.dy);
    canvas.rotate(-radians);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(0, 0), width: blockSize, height: blockSize),
        blockPaint);

    // Flechas del primer cuadrado
    drawArrow(canvas, Offset(0, -blockSize / 2), -math.pi / 2, 50,
        Colors.green); // Abajo
    drawArrow(canvas, Offset(-blockSize / 2, 0), math.pi, 50,
        Colors.redAccent); // Izquierda
    drawArrow(
        canvas, Offset(blockSize / 2, 0), 0, 50, Colors.orange); // Derecha

    canvas.restore();

    // Flecha vertical desde el centro del primer cubo
    drawVerticalArrow(canvas, blockCenter1, 60, Colors.blue);

    // Segundo cuadrado sin rotar
    final Offset blockCenter2 = Offset(
      (pointB.dx + pointC.dx) / 2,
      (pointB.dy + pointC.dy) / 2,
    );

    canvas.drawRect(
        Rect.fromCenter(
            center: blockCenter2, width: blockSize, height: blockSize),
        blockPaintSecondary);

    // Flechas del segundo cuadrado
    drawArrow(canvas, Offset(blockCenter2.dx, blockCenter2.dy - blockSize / 2),
        math.pi / 2, 80, Colors.purple); // Arriba
    drawArrow(canvas, Offset(blockCenter2.dx, blockCenter2.dy + blockSize / 2),
        -math.pi / 2, 80, Colors.pink); // Abajo

    // Dibujar la polea
    final pulleyCenter = Offset(pointC.dx, pointC.dy);
    final pulleyRadius = 20.0;
    final pulleyPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pulleyCenter, pulleyRadius, pulleyPaint);

    // Dibujar la cuerda que conecta los dos cuerpos
    final ropePaint = Paint()
      ..color = Colors.brown
      ..colorFilter = ColorFilter.mode(Colors.brown, BlendMode.srcOver)
      ..strokeWidth = 3;

    final Offset ropeStart =
        blockCenter1; // Conectar al centro del primer cuadrado
    final Offset ropeEnd =
        blockCenter2; // Conectar al centro del segundo cuadrado

    canvas.drawLine(ropeStart, pulleyCenter, ropePaint);
    canvas.drawLine(pulleyCenter, ropeEnd, ropePaint);
  }

  void drawArrow(Canvas canvas, Offset center, double direction, double length,
      Color color) {
    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final double arrowHeadLength = 10.0;
    final Offset end = Offset(center.dx + length * math.cos(direction),
        center.dy + length * math.sin(direction));
    canvas.drawLine(center, end, arrowPaint);

    // Dibujar la cabeza de la flecha
    canvas.drawLine(
        end,
        Offset(end.dx - arrowHeadLength * math.cos(direction - math.pi / 6),
            end.dy - arrowHeadLength * math.sin(direction - math.pi / 6)),
        arrowPaint);
    canvas.drawLine(
        end,
        Offset(end.dx - arrowHeadLength * math.cos(direction + math.pi / 6),
            end.dy - arrowHeadLength * math.sin(direction + math.pi / 6)),
        arrowPaint);
  }

  void drawVerticalArrow(
      Canvas canvas, Offset center, double length, Color color) {
    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final double arrowHeadLength = 10.0;
    final Offset end = Offset(center.dx, center.dy + length);
    canvas.drawLine(center, end, arrowPaint);

    // Dibujar la cabeza de la flecha
    canvas.drawLine(end,
        Offset(end.dx - arrowHeadLength, end.dy - arrowHeadLength), arrowPaint);
    canvas.drawLine(end,
        Offset(end.dx + arrowHeadLength, end.dy - arrowHeadLength), arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SecondDiagramPainter extends CustomPainter {
  final Color arrowColorUp;
  final Color arrowColorDown;

  SecondDiagramPainter(
      {required this.arrowColorUp, required this.arrowColorDown});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double length = size.height * 0.8;
    final Offset pointA = Offset(size.width / 2, (size.height - length) / 2);
    final Offset pointB = Offset(pointA.dx, pointA.dy + length);

    // Dibujar la línea vertical
    canvas.drawLine(pointA, pointB, paint);

    final blockPaint = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.fill;
    final double blockSize = 40.0;

    // Centro del cuadro rojo
    final Offset blockCenter = Offset(
      (pointA.dx + pointB.dx) / 2,
      (pointA.dy + pointB.dy) / 2,
    );

    // Dibujar el cuadro rojo en el centro de la línea
    canvas.drawRect(
        Rect.fromCenter(
            center: blockCenter, width: blockSize, height: blockSize),
        blockPaint);

    // Dibujar flechas en cada lado del rectángulo
    drawArrow(canvas, Offset(blockCenter.dx, blockCenter.dy - blockSize / 2),
        -math.pi / 2, 50, arrowColorUp); // Arriba
    drawArrow(canvas, Offset(blockCenter.dx, blockCenter.dy + blockSize / 2),
        math.pi / 2, 50, arrowColorDown); // Abajo
  }

  void drawArrow(Canvas canvas, Offset start, double direction, double length,
      Color color) {
    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final double arrowHeadLength = 10.0;

    final Offset end = Offset(start.dx + length * math.cos(direction),
        start.dy + length * math.sin(direction));
    canvas.drawLine(start, end, arrowPaint);

    // Dibujar la cabeza de la flecha
    canvas.drawLine(
        end,
        Offset(end.dx - arrowHeadLength * math.cos(direction - math.pi / 6),
            end.dy - arrowHeadLength * math.sin(direction - math.pi / 6)),
        arrowPaint);
    canvas.drawLine(
        end,
        Offset(end.dx - arrowHeadLength * math.cos(direction + math.pi / 6),
            end.dy - arrowHeadLength * math.sin(direction + math.pi / 6)),
        arrowPaint);
  }
}
