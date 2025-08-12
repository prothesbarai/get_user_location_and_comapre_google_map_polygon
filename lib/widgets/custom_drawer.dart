import 'package:flutter/material.dart';
import 'package:locationcomparewithcoordinates/utils/app_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
              colors: AppColor.colorArray,
              center: AlignmentDirectional(1, -1),
              stops: [0.0, 0.2, 0.2, 0.3, 0.3, 0.4,0.4,0.6,0.6,8.0,8.0,0.9,1.0],
              startAngle: 0.9,
              endAngle: 6,
          )
        ),

      ),

    );
  }
}
