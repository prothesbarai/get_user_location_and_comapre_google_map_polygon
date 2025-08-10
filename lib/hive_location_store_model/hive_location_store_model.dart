import 'package:hive/hive.dart';
part 'hive_location_store_model.g.dart';


@HiveType(typeId: 0)
class HiveLocationStoreModel extends HiveObject{

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? street;

  @HiveField(2)
  String? administrativeArea;

  @HiveField(3)
  String? subAdministrativeArea;

  @HiveField(4)
  String? thoroughfare;

  @HiveField(5)
  String? subThoroughfare;

  @HiveField(6)
  String? locality;

  @HiveField(7)
  String? subLocality;

  @HiveField(8)
  String? postalCode;

  @HiveField(9)
  String? isoCountryCode;

  @HiveField(10)
  String? country;

  @HiveField(11)
  double? latitude;

  @HiveField(12)
  double? longitude;

  @HiveField(13)
  int? locationId;


  HiveLocationStoreModel({
    this.name,
    this.street,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.thoroughfare,
    this.subThoroughfare,
    this.locality,
    this.subLocality,
    this.postalCode,
    this.isoCountryCode,
    this.country,
    this.latitude,
    this.longitude,
    this.locationId
  });

}