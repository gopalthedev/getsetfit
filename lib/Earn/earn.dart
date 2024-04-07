import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Earn extends StatefulWidget {
  const Earn({super.key});

  @override
  _EarnState createState() => _EarnState();
}

class _EarnState extends State<Earn> {
  Future<void> _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Redeem Your Coin")),
        backgroundColor: Colors.grey[50],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20), // Adjust top padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildRewardButton(
              label: "Flipkart",
              onTap: () {
                _launchURL('https://www.flipkart.com/');
              }, imageurl: 'asset/flipkartLogo.jpg',
            ),
            SizedBox(height: 41),
            _buildRewardButton(
              label: "Amazon",
              onTap: () {
                _launchURL('https://www.amazon.com/');
              }, imageurl: 'asset/Amazon-Logo.png',
            ),
            SizedBox(height: 41),
            _buildRewardButton(
              label: "Railway",
              onTap: () {
                _launchURL('https://indianrailways.gov.in/');
              }, imageurl: 'asset/Indian_Railways_logo.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardButton({required String label, required Function() onTap, required String imageurl}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 370.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Image(image: AssetImage(imageurl),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}