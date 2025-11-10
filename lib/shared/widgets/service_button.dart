import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';

Widget CircleButton({Function? onTab,String value="",String text="",IconData icon=Icons.add,String? path,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477),String? iconPath}) {

  return GestureDetector(
    onTap: (){
      if(onTab!=null)
        onTab();
    },


    child: Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Change to circle
            color: AppColors.backgroundColor,
            border: Border.all(
              color: AppColors.backgroundColor, // Change this to the color you want for the border
              width: 0.0, // Adjust the width of the border as needed
            ),
          ),
          // width: double.infinity,
          child:iconPath==null?Icon(icon,size: 30,color:AppColors.primary,):Image.asset(
            iconPath,  // Path to your SVG file
            height: 35,            // Set the height for the icon
            width: 35,             // Set the width (optional)
             color: AppColors.primary,
          ),
        ),
        SizedBox(height: 5,),
        Text(text,style: TextStyle(color: AppColors.primary,fontSize: 10), textAlign: TextAlign.center,)
      ],
    ),
  );
}


Widget ServiceButton({Function? onTab,String value="",String text="",IconData icon=Icons.add,
  Color? color, Color? onColor,String? iconPath,bool isIconPathColor=true}) {

  return GestureDetector(
    onTap: (){
      if(onTab!=null)
        onTab();
    },

    child: Container(
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(

          shape: BoxShape.rectangle,
          color: color??AppColors.secondly.withOpacity(.1),
          borderRadius: new BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: AppColors.secondly.withOpacity(.3), // Change this to the color you want for the border
            width: 0.0, // You can adjust the width of the border as needed
          ),
      ),
      width: double.infinity,
      //width: 100,

      // width: double.infinity,
      margin: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // width: double.infinity,

                child:iconPath==null?Icon(icon,size: 40,color:onColor??AppColors.secondly.withOpacity(.8),):
                Image.asset(
                  iconPath,  // Path to your SVG file
                  height: 35,            // Set the height for the icon
                  width: 35,             // Set the width (optional)
                  color:onColor??AppColors.secondly.withOpacity(.8),
                ),


            ),
          ),
          Text(text,style: TextStyle(color: AppColors.primary,fontSize: 12), textAlign: TextAlign.center,)
        ],
      ),
    ),
  );
}


Widget PrimaryButton({Function? onTab,String value="",String text="",IconData icon=Icons.add,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477)}) {

  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed:  onTab==null?null:(){
          onTab();
      },
      child:  Text(text??"",style: TextStyle(color: AppColors.onPrimary),),
      style: TextButton.styleFrom(
        backgroundColor:onTab==null? AppColors.primary.withOpacity(.5):AppColors.primary, // Background color
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
      ),
    ),
  );
}

Widget SecondaryButton({Function? onTab,String value="",String text="",IconData icon=Icons.add,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477)}) {

  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed:  (){
        if(onTab!=null)
          onTab();
      },
      child:  Text(text??"",style: TextStyle(color: AppColors.primary),),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.secondly, // Background color
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
      ),
    ),
  );
}

Widget SecondaryOutlineButton({Function? onTab,String value="",String text="",IconData? icon,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477),bool? isLoading=false}) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed: isLoading==true?null: (){
        if(onTab!=null)
          onTab();
      },
      child:   Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon==null?Container():Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(icon,color:AppColors.secondly ,size: 13,),
              ),
              isLoading==true?Center(child: WaveLoader(color: AppColors.secondly,size: 25)):
              Text(text??"",style: TextStyle(color: AppColors.secondly),),
            ],
          )
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent, // Transparent background color
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
          side: BorderSide(color: AppColors.secondly, width: 1), // Outline color and width
        ),
      ),
    ),
  );
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed:  (){
        if(onTab!=null)
          onTab();
      },
      child:   Row(
        children: [
          icon==null?Container():Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(icon,color:AppColors.secondly ,size: 13,),
          ),
          Text(text??"",style: TextStyle(color: AppColors.secondly),),
        ],
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent, // Transparent background color
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
          side: BorderSide(color: AppColors.secondly, width: 1), // Outline color and width
        ),
      ),
    ),
  );
}

Widget DefaultButton({Function? onTab,String value="",String text="",IconData icon=Icons.add,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477)}) {

  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed:  (){
        if(onTab!=null)
          onTab();
      },
      child:  Row(
        children: [
          Icon(icon,color:AppColors.gray.withOpacity(.6) ,size: 14,),
          SizedBox(width: 8,),
          Text(text??"",style: TextStyle(color: AppColors.gray.withOpacity(.6)),),
        ],
      ),
      style: TextButton.styleFrom(

        backgroundColor: AppColors.gray.withOpacity(.01), // Background color
        // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        side: BorderSide(color: AppColors.gray.withOpacity(.1), width: 1),
      ),
    ),
  );
}

Widget DangerButton({Function? onTab,String value="",String text="",IconData? icon,
  Color color= const Color(0xFF245896), Color onColor= const Color(0xff429477)}) {

  return  Container(
    // color: Colors.amberAccent,
    // height: 40,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed:  (){
          if(onTab!=null)
            onTab();
        },
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon==null?Container():Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(icon,color:Colors.white.withOpacity(.8) ,size: 13,),
            ),
            Text(text??"",style: TextStyle(color: Colors.white.withOpacity(.8)),),
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.danger, // Background color
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
        ),
      ),
    ),
  );
}


Widget AppButton({Function? onTab,String value="",String text="",IconData? icon,
  Color color= AppColors.defaultColor, Color onColor= AppColors.defaultColor,bool isFullWidth=true,bool isOutline=false}) {

  return  TextButton(
    onPressed:  (){
      if(onTab!=null)
        onTab();
    },
    child:  Row(
      mainAxisSize:isFullWidth?MainAxisSize.max:MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon==null?Container():Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(icon,color:Colors.white.withOpacity(.8) ,size: 13,),
        ),
        Text(text??"",style: TextStyle(color: isOutline?color:Colors.white.withOpacity(.8)),),
      ],
    ),
    style:isOutline==false?TextButton.styleFrom(
      backgroundColor: color, // Background color
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
    ):TextButton.styleFrom(
     backgroundColor: Colors.transparent, // Transparent background color
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0), // Rounded corners
      side: BorderSide(color: color, width: 1), // Outline color and width
    ),
  ),
  );
}

Widget AppButtonSmall({Function? onTab,String value="",String text="",IconData? icon,
  Color color= AppColors.defaultColor, Color onColor= AppColors.defaultColor,bool isFullWidth=true,bool isOutline=false}) {

  return  TextButton(
    onPressed:  (){
      if(onTab!=null)
        onTab();
    },
    child:  Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          color: isOutline?Colors.transparent:color,
          borderRadius: BorderRadius.circular(15.0), // Set the radius here
          border: isOutline
              ? Border.all(color: color, width: 1) // Border when outline is true
              : null, // No bor
        ),
        child: Row(
          mainAxisSize:isFullWidth?MainAxisSize.max:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon==null?Container():Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(icon,color:isOutline?color:Colors.white.withOpacity(.8) ,size: 13,),
            ),
            Text(text??"",style: TextStyle(color: isOutline?color:Colors.white.withOpacity(.8)),),
          ],
        )
    ),

  );
}

Widget AppCircleButton({Function? onTab,String value="",String text="",IconData? icon,}) {

  return  GestureDetector(onTap: (){
       onTab!();
    // _filter.classificationId = null;
    // setState((){});
  }, child:  CircleAvatar(
    radius: 12, // Size of the circle
    backgroundColor: Colors.grey.shade200,
    child: Icon(
      icon,
      color: Colors.grey.shade600,
      size: 12,
    ),
  ),);
}
class AppMediumButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const AppMediumButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // 👈 fixed width to keep symmetry
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // 👈 smaller compact padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // 👈 small rounded corners
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 11, // 👈 smaller font
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
