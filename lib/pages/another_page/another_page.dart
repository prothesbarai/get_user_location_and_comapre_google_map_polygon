import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locationcomparewithcoordinates/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../provider/location_provider.dart';

class AnotherPage extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String countryCode;
  const AnotherPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
  });

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  bool _isLoading = false;
  String? lastLocationId;



  Future<void> sendToGoogleSheet(String name, String latitude, String longitude, String locationName, String locationId, String countryCode) async {
    setState(() {_isLoading = true;});

    final url = Uri.parse("https://script.google.com/macros/s/AKfycbxlog5FdiD0FH4kCWfgqT_WuVyl0X3BwddLsRul41_DfpfYwb8UzVYNqgDi9N1zJq3U6A/exec");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "locationName": locationName,
        "locationId": locationId,
        "countryCode": countryCode,
      }),
    );

    lastLocationId = locationId;

    if(response.statusCode == 302){
      if(mounted){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.check_circle_outline_rounded,color: Colors.green,),
                      SizedBox(height: 10,),
                      Text('Update'),
                    ],
                  )
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Successfully Update Data'),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {Navigator.of(context).pop();},
                      child: Text('OK'),
                    ),
                  ],
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
    final name = "Prothes Barai";
    bool isSameLocation = lastLocationId != null && lastLocationId == locationProvider.locationId.toString();

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
                    onPressed: _isLoading || isSameLocation ? null : (){
                      sendToGoogleSheet(name, widget.latitude, widget.longitude,"${locationProvider.locationName}", "${locationProvider.locationId}",widget.countryCode);
                    },
                    child: _isLoading ? Text("Processing..."):Text(isSameLocation ? "Updated" : "Upload Data to Google Sheet"),
                ),

              ],
            ),
          )
      ),

    );
  }
}
