// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_location_store_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLocationStoreModelAdapter
    extends TypeAdapter<HiveLocationStoreModel> {
  @override
  final int typeId = 0;

  @override
  HiveLocationStoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLocationStoreModel(
      name: fields[0] as String?,
      street: fields[1] as String?,
      administrativeArea: fields[2] as String?,
      subAdministrativeArea: fields[3] as String?,
      thoroughfare: fields[4] as String?,
      subThoroughfare: fields[5] as String?,
      locality: fields[6] as String?,
      subLocality: fields[7] as String?,
      postalCode: fields[8] as String?,
      isoCountryCode: fields[9] as String?,
      country: fields[10] as String?,
      latitude: fields[11] as double?,
      longitude: fields[12] as double?,
      locationId: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLocationStoreModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.street)
      ..writeByte(2)
      ..write(obj.administrativeArea)
      ..writeByte(3)
      ..write(obj.subAdministrativeArea)
      ..writeByte(4)
      ..write(obj.thoroughfare)
      ..writeByte(5)
      ..write(obj.subThoroughfare)
      ..writeByte(6)
      ..write(obj.locality)
      ..writeByte(7)
      ..write(obj.subLocality)
      ..writeByte(8)
      ..write(obj.postalCode)
      ..writeByte(9)
      ..write(obj.isoCountryCode)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.locationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLocationStoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
