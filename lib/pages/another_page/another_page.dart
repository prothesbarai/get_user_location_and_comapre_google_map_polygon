import 'package:flutter/material.dart';
import 'package:locationcomparewithcoordinates/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../provider/location_provider.dart';

class AnotherPage extends StatelessWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("LocationName : ${locationProvider.locationName}",style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.bold),),
                Text("LocationId : ${locationProvider.locationId}",style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.bold),),

              ],
            ),
          )
      ),

    );
  }
}
