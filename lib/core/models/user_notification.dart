import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserNotification {
  int? id;
  String? title;
  bool? isActive;
  String? detail;
  String? type;
  DateTime? createdDate;
  bool? isRead;

  Color get color =>(isRead??false)?AppColors.gray.withOpacity(.5):type=='success'?AppColors.success:
  type=='warning'?AppColors.warning:
  type=='danger'?AppColors.danger:
  type=='info'?AppColors.info:AppColors.gray;

  String get formattedDate {
    if (createdDate == null) return '';
    return timeago.format(createdDate!, locale: 'ar', allowFromNow: true);
    return DateFormat('yyyy-MM-dd HH:mm').format(createdDate!);
  }

  UserNotification.shallowCopy(UserNotification other)
      : id = other.id,
        title = other.title,
        isActive = other.isActive,
        detail = other.detail,
        type = other.type,
        isRead = other.isRead,
        createdDate = other.createdDate;


  // Default constructor
 UserNotification({
    this.id,
    this.title,
    this.isActive,
    this.detail,
    this.type,
    this.isRead,
    this.createdDate,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {

    return UserNotification(
      id: JsonUtils.toInt(json['id']),
      title: JsonUtils.toText(json['title']),
      detail: JsonUtils.toText(json['message']),
      createdDate: JsonUtils.toDateTime(json['sent_date']),
      isRead: JsonUtils.toBoolean(json['read']),
      type: JsonUtils.toText(json['type_background']),

    );
  }
}
//
class UserNotificationData extends PagedData<UserNotification>{



}

