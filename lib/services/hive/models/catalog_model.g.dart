// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatalogModelAdapter extends TypeAdapter<CatalogModel> {
  @override
  final int typeId = 0;

  @override
  CatalogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatalogModel(
      title: fields[0] as String,
      description: fields[1] as String,
      children: (fields[2] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CatalogModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
