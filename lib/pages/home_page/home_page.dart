import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:locationcomparewithcoordinates/pages/widgets/custom_app_bar.dart';
import 'package:locationcomparewithcoordinates/pages/widgets/custom_drawer.dart';
import 'package:turf/along.dart' as turf;
import 'package:turf/boolean.dart' hide Position;
import '../../hive_location_store_model/hive_location_store_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _message = "Loading...";
  String locationName = "";
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
            "${savedLocation.name}\n"
            "${savedLocation.street}\n"
            "${savedLocation.administrativeArea}\n"
            "${savedLocation.subAdministrativeArea}\n"
            "${savedLocation.thoroughfare}\n"
            "${savedLocation.subThoroughfare}\n"
            "${savedLocation.locality}\n"
            "${savedLocation.subLocality}\n"
            "${savedLocation.postalCode}\n"
            "${savedLocation.isoCountryCode}\n"
            "${savedLocation.country}\n";
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

      final dhanmondiPolygon = turf.Polygon(coordinates: [
        [
          turf.Position(90.37644105341138, 23.73814930923713),
          turf.Position(90.38324004130533, 23.739415608803697),
          turf.Position(90.3820332945362, 23.744642332072672),
          turf.Position(90.37526373949032, 23.75633434526398),
          turf.Position(90.36767006469995, 23.75172770964238),
          turf.Position(90.37644105341138, 23.73814930923713),
        ]
      ]);


      final banashreePolygon = turf.Polygon(coordinates: [
        [
          turf.Position(90.42435438080707, 23.765310646915452),
          turf.Position(90.42435438080707, 23.764371360192087),
          turf.Position(90.42528835891386, 23.764371360192087),
          turf.Position(90.42528835891386, 23.765310646915452),
          turf.Position(90.42435438080707, 23.765310646915452),
        ]
      ]);


      final isSouthBanashreePolygon = turf.Polygon(coordinates: [
        [
          turf.Position(90.44043052329232, 23.75945393989916),
          turf.Position(90.44043052329232, 23.756992752880237),
          turf.Position(90.44435298937998, 23.756992752880237),
          turf.Position(90.44435298937998, 23.75945393989916),
          turf.Position(90.44043052329232, 23.75945393989916),
        ]
      ]);



      final userPosition = turf.Position(position.longitude, position.latitude);
      bool inDhanmondi = booleanPointInPolygon(userPosition, dhanmondiPolygon);
      bool inBanashree = booleanPointInPolygon(userPosition, banashreePolygon);
      bool isSouthBanashree = booleanPointInPolygon(userPosition, isSouthBanashreePolygon);




      if (inDhanmondi) {
        setState(() {locationName = "Dhanmondi";});
      } else if (inBanashree) {
        locationName = "Banashree";
      }else if (isSouthBanashree) {
        locationName = "Prothes House :\n South Banashree";
      }
      else {
        setState(() {locationName = "User is in neither Dhanmondi nor Banashree";});
      }


      List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMark[0];
      final customPlace = HiveLocationStoreModel(
          name: locationName,
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
          longitude: position.longitude
      );
      await locationBox.put("store_location", customPlace);
      HiveLocationStoreModel? updatedLocation = locationBox.get("store_location");
      String locationDetails = "Lat : ${updatedLocation?.latitude}   Long : ${updatedLocation?.longitude}\n"
          "Location : \n"
          "${updatedLocation?.name}\n"
          "${updatedLocation?.street}\n"
          "${updatedLocation?.administrativeArea}\n"
          "${updatedLocation?.subAdministrativeArea}\n"
          "${updatedLocation?.thoroughfare}\n"
          "${updatedLocation?.subThoroughfare}\n"
          "${updatedLocation?.locality}\n"
          "${updatedLocation?.subLocality}\n"
          "${updatedLocation?.postalCode}\n"
          "${updatedLocation?.isoCountryCode}\n"
          "${updatedLocation?.country}\n";
      setState(() {_message = "Welcome\nYour Current location:\n$locationDetails\n";});
    }catch(e){
      setState(() {_message = "Error fetching location: $e";});
    }finally{
      setState(() {_isLoading = false;});
    }
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
                SizedBox(height: 100,),
                Text("${updatedLocation?.name}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue),),

              ],
            ),
          )
      ),

    );
  }
}





