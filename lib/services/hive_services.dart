import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../hive_location_store_model/hive_location_store_model.dart';

class HiveServices {

  static Future<void> initHive() async{
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(HiveLocationStoreModelAdapter());
    await Hive.openBox("IFStoreLocation");
    await Hive.openBox<HiveLocationStoreModel>("StoreUserLocation");
  }


}