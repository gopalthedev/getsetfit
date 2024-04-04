import 'package:flutter/material.dart';


class Nutrition extends StatelessWidget {
  Nutrition({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            centerTitle: true, // Center the title text
            title: Text("Nutrition"),
            leading: Center(
              child: Icon(Icons.restaurant), // Center the icon horizontally
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildRewardButton(
                label: "Explore Healthy Options",
                subText: "Discover Personalized Meal Plans For You",
              ),
              SizedBox(height: 20),
              _buildRowOfRectangles([
                RectangleData(
                  imagePath: 'asset/1.jpg',
                  mainText: 'Balanced Diet',
                  subText: 'Customized',
                  opacity: 0.4,
                ),
                RectangleData(
                  imagePath: 'asset/2.png',
                  mainText: 'Time Restricted',
                  subText: 'Customized',
                  opacity: 0.4,
                ),
              ]),
              SizedBox(height: 20),
              _buildRowOfRectangles([
                RectangleData(
                  imagePath: 'asset/3.png',
                  mainText: 'Reduce Carb Intake',
                  subText: 'Tailored Low',
                  opacity: 0.4,
                ),
                RectangleData(
                  imagePath: 'asset/4.png',
                  mainText: 'Natural Food',
                  subText: 'Organic Meal',
                  opacity: 0.4,
                ),
              ]),
              SizedBox(height: 20),
              _buildRowOfRectangles([
                RectangleData(
                  imagePath: 'asset/5.jpg',
                  mainText: 'No Gluten Intake',
                  subText: 'Customized',
                  opacity: 0.4,
                ),
                RectangleData(
                  imagePath: 'asset/6.jpg',
                  mainText: 'Plant Focused Eating',
                  subText: 'Personalized',
                  opacity: 0.4,
                ),
              ]),
            ],
          ),
        ),
      );
  }

  Widget _buildRewardButton({required String label, required String subText}) {
    return Container(
      width: double.infinity,
      height: 170, // Increased height to 170px
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            subText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Explore button action
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button background color blue
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Button border radius
                ),
              ),
            ),
            child: Text(
              'Explore', // Button text
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangle(RectangleData data) {
    return Container(
      width: 150,
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: data.opacity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(data.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.mainText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  data.subText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowOfRectangles(List<RectangleData> dataList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dataList.map((data) => _buildRectangle(data)).toList(),
    );
  }
}

class RectangleData {
  final String imagePath;
  final String mainText;
  final String subText;
  final double opacity;

  RectangleData({
    required this.imagePath,
    required this.mainText,
    required this.subText,
    required this.opacity,
  });
}