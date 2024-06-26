import 'package:enrx_calculator/pages/company_links.dart';
import 'package:enrx_calculator/pages/micronutrients_page.dart';
import 'package:enrx_calculator/pages/ons_page.dart.dart';
import 'package:flutter/material.dart';
import 'about_app.dart';
import 'guide_page.dart';
import 'other_links.dart';

/// NOTE: use apk signer to sign the aab and not the jsd-keystore

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
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 25),
                    color: const Color(0xFF422546),
                    height: 140,
                    width: double.infinity,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ENRX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Calculator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: const Color(0xFF422546),
                      height: 160,
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
      if (index == 0) {  // Assuming index 0 corresponds to 'ONS/TF Formula'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TFFormulaPage(),
          ),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicronutrientsPage(),
          ),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyLinksPage(),
          ),
        );
      } else if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherLinksPage(),
          ),
        );
      } else if (index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuidePage(),
          ),
        );
      } else if (index == 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutAppPage(),
          ),
        );
      }
      // Add more conditions for other menu items as needed
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
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/image${index + 1}.png', height: 45, width: 45,),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label),
          ),
        ],
      ),
    ),
  );
}

// Wave Clipper watch tutorial here
// https://www.youtube.com/watch?v=8QdLBQhnHAQ

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105.0);
    var secondEnd = Offset(size.width, size.height - 10.0);
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}


