import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
// import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';

// class ImageBean extends DragBean {
//   ImageBean({
//     this.originPath,
//     this.middlePath,
//     this.thumbPath,
//     this.originalWidth,
//     this.originalHeight,
//   });

//   /// origin picture file path.
//   String originPath;

//   /// middle picture file path.
//   String middlePath;

//   /// thumb picture file path.
//   /// It is recommended to use a thumbnail picture，because the original picture is too large,
//   /// it may cause repeated loading and cause flashing.
//   String thumbPath;

//   /// original image width.
//   int originalWidth;

//   /// original image height.
//   int originalHeight;
// }

class CityModel extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  CityModel({
    this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => json.encode(this);
}

class ContactInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  Color bgColor;
  IconData iconData;

  String img;
  String id;
  String firstletter;

  ContactInfo({
    this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstletter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id']?.toString(),
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': img,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => json.encode(this);
}
