import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:locationcomparewithcoordinates/pages/another_page/another_page.dart';
import 'package:provider/provider.dart';
import 'package:turf/along.dart' as turf;
import 'package:turf/boolean.dart' hide Position;
import '../../hive_location_store_model/hive_location_store_model.dart';
import '../../provider/location_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/polygons.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _message = "Loading...";
  bool _isLoading = false;
  late Box ifStoreLocation;
  late Box locationBox;



  @override
  void initState() {
    super.initState();
    checkFirstTimeAndSetLocation();
  }



  Future<void> checkFirstTimeAndSetLocation() async{
    ifStoreLocation = Hive.box("IFStoreLocation");
    locationBox = Hive.box<HiveLocationStoreModel>("StoreUserLocation");

    bool permissionGranted = await handelLocationPermission();
    if(!permissionGranted) return;

    bool isFirstTime = ifStoreLocation.get('first_time',defaultValue: true);
    if(isFirstTime){
      await fetchLocation();
      await ifStoreLocation.put('first_time', false);
    }else{
      HiveLocationStoreModel? savedLocation = locationBox.get("store_location");
      if(savedLocation == null){
        setState(() {_message = "No saved location found.";});
      }else{
        String locationDetails = "Lat : ${savedLocation.latitude}   Long : ${savedLocation.longitude}\n"
            "Location : \n"
            "Name : ${savedLocation.name}\n"
            "LocationId : ${savedLocation.locationId}\n"
            "Street : ${savedLocation.street}\n"
            "AdministrativeArea : ${savedLocation.administrativeArea}\n"
            "SubAdministrativeArea : ${savedLocation.subAdministrativeArea}\n"
            "Thoroughfare : ${savedLocation.thoroughfare}\n"
            "SubThoroughfare : ${savedLocation.subThoroughfare}\n"
            "Locality : ${savedLocation.locality}\n"
            "SubLocality : ${savedLocation.subLocality}\n"
            "PostalCode : ${savedLocation.postalCode}\n"
            "IsoCountryCode : ${savedLocation.isoCountryCode}\n"
            "Country ${savedLocation.country}\n";
        setState(() {_message = "Welcome back!\nYour Current location:\n$locationDetails\n";});
      }
    }
  }


  Future<bool> handelLocationPermission() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      setState(() {_message = "Location services are disabled.";});
      if(mounted){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Location Disabled"),
                content: Text("Please enable location services."),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
        );
      }
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        setState(() {_message = "Location permission denied.";});
        return false;
      }
    }
    if(permission == LocationPermission.deniedForever){
      setState(() {_message = "Permission permanently denied. Please enable manually.";});
      if(mounted){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Permission Required"),
                content: Text("Please enable location permission from device settings."),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
        );
      }
      return false;
    }
    return true;
  }


  Future<void> fetchLocation() async{
    setState(() {_isLoading = true;});
    try{

      Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100));

      final userPosition = turf.Position(position.longitude, position.latitude);
      //final userPosition = turf.Position(90.429941, 23.789740);

      final locationInfo = getLocationInfo(userPosition);


      List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMark[0];
      final customPlace = HiveLocationStoreModel(
          name: locationInfo["name"],
          street: place.street,
          administrativeArea: place.administrativeArea,
          subAdministrativeArea: place.subAdministrativeArea,
          thoroughfare: place.thoroughfare,
          subThoroughfare: place.subThoroughfare,
          locality: place.locality,
          subLocality: place.subLocality,
          postalCode: place.postalCode,
          isoCountryCode: place.isoCountryCode,
          country: place.country,
          latitude: position.latitude,
          longitude: position.longitude,
          locationId: locationInfo["locationId"],
      );
      await locationBox.put("store_location", customPlace);

      if(mounted){
        Provider.of<LocationProvider>(context, listen: false).refreshLocation();
      }

      HiveLocationStoreModel? updatedLocation = locationBox.get("store_location");
      String locationDetails = "Lat : ${updatedLocation?.latitude}   Long : ${updatedLocation?.longitude}\n"
          "Location : \n"
          "Name : ${updatedLocation?.name}\n"
          "LocationId : ${updatedLocation?.locationId}\n"
          "Street : ${updatedLocation?.street}\n"
          "AdministrativeArea : ${updatedLocation?.administrativeArea}\n"
          "SubAdministrativeArea : ${updatedLocation?.subAdministrativeArea}\n"
          "Thoroughfare : ${updatedLocation?.thoroughfare}\n"
          "SubThoroughfare : ${updatedLocation?.subThoroughfare}\n"
          "Locality : ${updatedLocation?.locality}\n"
          "SubLocality : ${updatedLocation?.subLocality}\n"
          "PostalCode : ${updatedLocation?.postalCode}\n"
          "IsoCountryCode : ${updatedLocation?.isoCountryCode}\n"
          "Country ${updatedLocation?.country}\n";
      setState(() {_message = "Welcome\nYour Current location:\n$locationDetails\n";});
    }catch(e){
      setState(() {_message = "Error fetching location: $e";});
    }finally{
      setState(() {_isLoading = false;});
    }
  }


  /// >>  If You Use Else If
  /*Map<String, dynamic> getLocationInfo(turf.Position userPosition) {
    if (booleanPointInPolygon(userPosition, dhanmondiPolygon)) {
      return {"name": "Dhanmondi", "locationId": 8,};
    } else if (booleanPointInPolygon(userPosition, banashreePolygon)) {
      return {"name": "Banashree", "locationId": 9,};
    } else if (booleanPointInPolygon(userPosition, southBanashreePolygon)) {
      return {"name": "South Banashree", "locationId": 10,};
    } else if (booleanPointInPolygon(userPosition, mirpurPolygon)) {
      return {"name": "Mirpur", "locationId": 11,};
    } else if (booleanPointInPolygon(userPosition, baddaPolygon)) {
      return {"name": "Badda", "locationId": 12,};
    } else {
      return {"name": "Out Of Dhaka City", "locationId": 13,};
    }
  }*/


  Map<String, dynamic> getLocationInfo(turf.Position userPosition) {
    final polygons = [
      {"name": "Dhanmondi", "locationId": 8, "polygon": dhanmondiPolygon},
      {"name": "Banashree", "locationId": 9, "polygon": banashreePolygon},
      {"name": "South Banashree", "locationId": 10, "polygon": southBanashreePolygon},
      {"name": "Mirpur", "locationId": 11, "polygon": mirpurPolygon},
      {"name": "Badda", "locationId": 12, "polygon": baddaPolygon},
    ];

    for (final items in polygons) {

      final String name = items["name"] as String;
      final int locationId = items["locationId"] as int;
      final turf.GeoJSONObject polygon = items["polygon"] as turf.GeoJSONObject;

      if (booleanPointInPolygon(userPosition, polygon)) {
        return {
          "name": name,
          "locationId": locationId,
        };
      }

    }

    return {
      "name": "Out Of Dhaka City",
      "locationId": 13,
    };
  }







  @override
  Widget build(BuildContext context) {

    HiveLocationStoreModel? updatedLocation = locationBox.get("store_location");

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SafeArea(
          child: _isLoading ? Center(child: CircularProgressIndicator(),):
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Text(_message,style: TextStyle(fontSize: 20),),
                SizedBox(height: 20,),
                Text("LocationName : ${updatedLocation?.name}\nLocationId : ${updatedLocation?.locationId}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.blue),textAlign: TextAlign.center,),
                SizedBox(height: 20,),

                Wrap(
                  spacing: 8,
                  children: [

                    ElevatedButton(
                        onPressed: fetchLocation,
                        child: Text("Update Location")
                    ),

                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherPage(latitude: "${updatedLocation?.latitude}",longitude: "${updatedLocation?.longitude}",countryCode: "${updatedLocation?.isoCountryCode}",),));
                        },
                        child: Text("Next Page")
                    )

                  ],
                )

              ],
            ),
          ),
      ),

    );
  }
}





