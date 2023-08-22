import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidePage extends StatelessWidget {
  final TextStyle _customTextStyle = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF422546),
        title: const Text(
          'How to use the app',
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
                    text: 'The EN Rx Calculator has two main features:\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'A. Oral Nutritional Supplements (ONS) Formula:\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'You can enter the number of scoops of serving aimed for the nutritional requirement and automatically view the equivalent macronutrients and micronutrient contents.\nYou may also go to the Calorie Section to enter the amount of kcal desired and view the equivalent nutrient contents by calorie.\n\n',
                  ),
                  TextSpan(
                    text: 'B. Micronutrients\n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'This simply helps us determine the amount of nutrients contained per capsule or syrup serving of an enteral multivitamin and mineral preparation.\n\n',
                  ),
                  TextSpan(
                    text: 'Any concern about the App?',
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
                  String subject = 'EN RX Calculator: Contact Us';
                  String body = '';
                  _launchGmail(subject, body);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/email.png',
                        height: 75,
                        width: 75,
                      ),
                      Text(
                        'Contact Us',
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

  //open gmail
  Future<void> _launchGmail(String subject, String body) async {
    final Uri gmail = Uri.parse(
        'mailto:enrxcalculator2022@gmail.com?subject=$subject&body=$body');
    if (!await launchUrl(gmail, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Gmail');
    }
  }
}
