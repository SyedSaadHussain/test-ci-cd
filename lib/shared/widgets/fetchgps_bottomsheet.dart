import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';


class GPSPermissionBottomSheet extends StatefulWidget {
  final GPSPermission permission;
  final VoidCallback onAuthorized;

  const GPSPermissionBottomSheet({
    required this.permission,
    required this.onAuthorized,
  });

  @override
  _GPSPermissionBottomSheetState createState() => _GPSPermissionBottomSheetState();
}

class _GPSPermissionBottomSheetState extends State<GPSPermissionBottomSheet> {

  bool isMethodCall=false;
  @override
  void initState() {
    super.initState();

    widget.permission.checkPermission();


    widget.permission.listner.listen((_) {
        print("listener");
        if (!mounted) return;
        setState(() {});
        if ((Config.disableValidation || widget.permission.status == GPSPermissionStatus.authorize)
            && isMethodCall==false) {
          //Navigator.pop(context);
          isMethodCall=true;
          widget.onAuthorized();
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Cross button row at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'location_check'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // ✅ Dismisses the modal sheet
                },
              )
            ],
          ),
          SizedBox(height: 10),

          // ✅ Status row
          Row(
            children: [
              widget.permission.status == GPSPermissionStatus.authorize
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.warning_amber, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.permission.statusDesc,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              widget.permission.status == GPSPermissionStatus.authorize?ElevatedButton(
                  onPressed: () {
                    this.widget.onAuthorized();
                  },
                  child: Text('close'.tr())):Container(),


            ],
          ),

          if (widget.permission.status ==
              GPSPermissionStatus.unAuthorizeLocation)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              // child: Text(
              //   'You are ${widget.permission.outsideRadius
              //       .abs()} meters outside the allowed area.',
              //   style: TextStyle(color: Colors.red),
              // ),
            ),

          SizedBox(height: 10),

          if (!widget.permission.isCompleted)
            Center(child: CircularProgressIndicator()),

          if (widget.permission.showTryAgainButton)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (widget.permission.status ==
                      GPSPermissionStatus.locationDisabled) {
                    widget.permission.enableMobileLocation();
                  } else if (widget.permission.status ==
                      GPSPermissionStatus.permissionDenied) {
                    widget.permission.allowPermission();
                  } else if (widget.permission.status ==
                      GPSPermissionStatus.failFetchCoordinate ||
                      widget.permission.status ==
                          GPSPermissionStatus.unAuthorizeLocation) {
                    widget.permission.getCurrentLocation();
                  }
                  setState(() {});
                },
                child: Text('fetch_gps_again'.tr()),
              ),
            ),
        ],
      ),
    );
  }
}
