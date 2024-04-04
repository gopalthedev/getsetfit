import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FitnessCategory extends StatelessWidget {
  const FitnessCategory(
      {super.key, required this.placeholderImage, required this.category});

  final AssetImage placeholderImage;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.black)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: placeholderImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              category,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
