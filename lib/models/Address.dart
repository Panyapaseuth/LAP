// To parse this JSON data, do
//
//     final reqLogin = reqLoginFromJson(jsonString);

import 'dart:convert';

Address AddressFromJson(String str) => Address.fromJson(json.decode(str));

String AddressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    this.id,
    this.nameLa,
    this.nameEn,
    this.provinceId,
  });

  String id;
  String nameLa;
  String nameEn;
  String provinceId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] == null ? null : json["id"],
    nameLa: json["name_la"] == null ? null : json["name_la"],
    nameEn: json["name_en"] == null ? null : json["name_en"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name_la": nameLa == null ? null : nameLa,
    "name_en": nameEn == null ? null : nameEn,
    "province_id": provinceId == null ? null : provinceId,
  };
}
