import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locationcomparewithcoordinates/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../provider/location_provider.dart';

class AnotherPage extends StatefulWidget {
  const AnotherPage({super.key});

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  bool _isLoading = false;



  Future<void> sendToGoogleSheet(String name, String email, String message) async {
    setState(() {_isLoading = true;});

    final url = Uri.parse("https://script.google.com/macros/s/AKfycby7wXb0MWAlZPKLpkpgh-J7NvgPZbmCIy8c5BjiO13HqS-uCZYKeyNlCKuU3Dh1uEwaww/exec");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "message": message,
      }),
    );

    if(response.statusCode == 302){
      if(mounted){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded),
                  SizedBox(width: 10,),
                  Text('Update'),
                ],
              ),
              content: Text('Successfully Update Data'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {_isLoading = false;});
  }


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

                SizedBox(height: 50,),

                ElevatedButton(
                    onPressed: (){sendToGoogleSheet("Prothes", "developerProthes@gmail.com", "Test");},
                    child: _isLoading ? Text("Processing..."):Text("Upload Data")
                ),

              ],
            ),
          )
      ),

    );
  }
}
