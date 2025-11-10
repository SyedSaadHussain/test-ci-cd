
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class RootedDevice extends StatelessWidget{

  RootedDevice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/headder.jpg', // Replace with your image URL
                fit: BoxFit.cover,
              ),
              Expanded(
                  child:Container(
                    color: Theme.of(context).primaryColor,


                  )
              )

            ],
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100,),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 50,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),

                      child: Center(child: Text('Rooted device detected',style: TextStyle(color: AppColors.onPrimary,fontSize: 25),textAlign: TextAlign.center,))),

                  SizedBox(height: 10,),
                  Expanded(child: Container(
                    width: double.infinity,
                    child: Container(
                      child:
                      Text("Root access detected. For your security, this app cannot run on rooted devices.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.onPrimary,

                            height: 1.8,fontSize: 16),),

                    ),
                  )),
                  SizedBox(height: 20,),

                  SizedBox(height: 5,),



                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}