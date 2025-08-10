import 'package:flutter/material.dart';
import 'package:locationcomparewithcoordinates/pages/home_page/home_page.dart';
import 'package:locationcomparewithcoordinates/provider/location_provider.dart';
import 'package:locationcomparewithcoordinates/services/hive_services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveServices.initHive();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
        ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


