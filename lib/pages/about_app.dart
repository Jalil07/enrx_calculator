import 'package:enrx_calculator/pages/web_page.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  final TextStyle _customTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.bold, // Added bold to the custom style
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF422546),
        title: const Text(
          'About this app',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            RichText(
              text: TextSpan(
                style: _customTextStyle,
                children: const <TextSpan>[
                  TextSpan(
                    text:
                        'EN Rx Calculator aims to calculate the dose of macronutrients and micronutrients contained in commercial enteral nutrition formulas to help guide clinicians and healthcare workers on quality prescription-making.\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The App is currently limited to formulas available in the Philippines and will be updated from time to time.\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'Features\n', // Bold header
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Calculates the Following\n\n'
                        '▪️  Calories by Scoops/Serving or Scoops/Serving to Calorie Equivalent\n'
                        '▪️  Macronutrients: Carbohydrate, Protein, Fat Contents\n'
                        '▪️  Micronutrients: Major Minerals (Sodium, Potassium Magnesium and more)\n'
                        '▪️  Micronutrients: Vitamins (Fat-soluble and Water-Soluble Vitamins)\n'
                        '▪️  Fibre Content\n'
                        '▪️  Immunonutrient Content\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'Disclaimer\n', // Bold header
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Please note that contents of products may change from time to time depending on company product updates.\n\n'
                        'The App must not be the sole source of reference\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy\n', // Bold header
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebPage(
                        linkUrl:
                            'https://jsdapplications.blogspot.com/2022/08/en-rx-calculator.html',
                        title: 'Privacy Policy',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/policy.png',
                        height: 75,
                        width: 75,
                      ),
                      Text(
                        'Click to read',
                        style: _customTextStyle,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
