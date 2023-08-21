import 'package:enrx_calculator/pages/ons_page.dart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<String> menuLabels = [
    'ONS/TF Formula',
    'Micronutrients',
    'Company Links',
    'More Links',
    'How To Use',
    'About App',
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1CD88),
      body: Stack(
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: RPSCustomPainter(),
                ),
                const SizedBox(
                  height: 175,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Opacity(
                        opacity: 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'EN RX',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Calculator',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: menuLabels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return menuStack(context, index, menuLabels[index]);
                  },
                ),
              ),
            ),
          ]
      ),
    );
  }
}

Widget menuStack(BuildContext context, int index, String label) {
  const double borderRadius = 12;
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TFFormulaPage(),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: const Color(0xFFF7F4E7),
        border: Border.all(
          width: 0,
          color: const Color(
            0xFFAFAD93,
          ), // Add a 3-pixel border stroke with color #AFAD93
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/image${index + 1}.png', height: 45, width: 45,),
          const SizedBox(height: 8),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label)),
        ],
      ),
    ),
  );
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 66, 37, 70)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(0,size.height*-0.0014286);
    path_0.lineTo(size.width*-0.0008333,size.height*0.7828571);
    path_0.quadraticBezierTo(size.width*0.0091667,size.height*0.7207143,size.width*0.0416667,size.height*0.7142857);
    path_0.cubicTo(size.width*0.1397917,size.height*0.7146429,size.width*0.8343750,size.height*0.7139286,size.width*0.9175000,size.height*0.7142857);
    path_0.cubicTo(size.width*0.9810417,size.height*0.7146429,size.width,size.height*0.6575000,size.width*1.0016667,size.height*0.5671429);
    path_0.quadraticBezierTo(size.width*1.0037500,size.height*0.4075000,size.width,size.height*0.0014286);
    path_0.lineTo(0,size.height*-0.0014286);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 66, 37, 70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


