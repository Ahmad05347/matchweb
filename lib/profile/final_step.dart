import 'package:flutter/material.dart';
import 'package:match_web_app/colors/elegant_colors.dart';

class FinalStep extends StatelessWidget {
  final String text;
  const FinalStep({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: ElegantColors.plum),
          SizedBox(height: 10),
          Text('$text Completed!', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('You can now start matching.'),
        ],
      ),
    );
  }
}
