import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/input_decoration_themes.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/menuRights.dart';
import 'package:mosque_management_system/core/models/service_menu.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/khutba/list/khutba_list_screen.dart';
import 'package:mosque_management_system/features/profile/profile_screen.dart';
import 'package:mosque_management_system/features/screens/all_mosque_request.dart';
import 'package:mosque_management_system/features/screens/all_mosques.dart';
import 'package:mosque_management_system/features/screens/assign_visit.dart';
import 'package:mosque_management_system/features/screens/create_masjid.dart';
import 'package:mosque_management_system/features/screens/create_visit.dart';
import 'package:mosque_management_system/features/screens/today_visits.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:provider/provider.dart';

import '../../core/constants/config.dart';
import '../mosque_utilities/mosque_utilities_menu.screen.dart';
import 'main_survey_visit.dart';


class Services extends StatefulWidget {
  // final CustomOdooClient client;
  // Services({required this.client});
  Services({Key? key}) : super(key: key);
  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends BaseState<Services> {
  List<ServiceMenu> menu=[];
  List<ServiceMenu> filteredMenu=[];

  Map<String, String> headersMap = {};

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _userService = UserService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    //_userService!.updateUserProfile(appUserProvider.userProfile);
    getMenuRights();
  }
  MenuRights? menuRights;
  UserService? _userService;
  TextEditingController _controller = TextEditingController();
  void getMenuRights(){

    _userService!.getMenuRightsAPI().then((value){

      menuRights=value;
      menu=menuRights!.getAllMenus();
      filteredMenu.addAll(menu);
      //loadLeaveMenu();
      appUserProvider.setMenu(value);
     
      setState(() {

      });

    }).catchError((e){
      
    });
  }

  // loadLeaveMenu(){
  //   if(menuRights!.createMosque??false)
  //    menu.add(ServiceMenu(name: 'create_new_mosque'.tr(), menuUrl: 'NEW_MOSQUE',icon: Icons.add,color: AppColors.primary));
  //   if(menuRights!.mosqueList!.isRights)
  //     menu.add(ServiceMenu(name: 'mosques'.tr(), menuUrl: 'MOSQUES',icon: Icons.mosque,color: AppColors.primary,filter:menuRights!.mosqueList!.filter ));
  //   //menu.add(ServiceMenu(name: 'Visit', menuUrl: 'NEW_VISIT',icon: Icons.person_pin_circle_outlined,color: AppColors.primary));
  //   if(menuRights!.searchVisit!.isRights)
  //     menu.add(ServiceMenu(name: 'search_visits'.tr(), menuUrl: 'TODAY_VISIT',icon: Icons.edit_calendar_sharp,color: AppColors.primary,filter:menuRights!.mosqueList!.filter));
  //   if(menuRights!.createVisit!)
  //     menu.add(ServiceMenu(name: 'create_new_visit'.tr(), menuUrl: 'CREATE_VISIT',icon: Icons.add_location_alt,color: AppColors.primary));
  //   menu.add(ServiceMenu(name: 'mosque_edit_request'.tr(), menuUrl: 'MOSQUE_EDIT_REQUEST',icon: Icons.edit_note_rounded,color: AppColors.primary));
  //   filteredMenu.addAll(menu);
  //
  // }
  void filterList(String searchText) {
    setState(() {
      filteredMenu = menu
          .where((item) =>
          item.name.tr().toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }
  // late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {


     // userProvider = Provider.of<UserProvider>(context);
    //loadLeaveMenu(userProvider.menuRights);
    return SafeArea(

      child: Scaffold(
        backgroundColor: AppColors.primary,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                //height: 170,
                child:
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),size: 25 , ),
                          ),
                        ),
                        Text('services'.tr(),style: TextStyle(fontSize: 22,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.8)),),

                      ],
                    ),
                    SizedBox(height: 5,),
                    Opacity(
                      opacity: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                        child: TextFormField(
                          controller: _controller,
                          onChanged: filterList,
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          decoration: AppInputDecoration.firstInputDecoration(context,label: "search".tr(),icon: Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(
                              filteredMenu.length,
                                  (index) =>
                                      ServiceButton(text: filteredMenu[index].name.tr(),icon: filteredMenu[index].icon,
                                          // color: filteredMenu[index].color,
                                      iconPath: filteredMenu[index].imagePath,
                                      isIconPathColor: filteredMenu[index].isImageColor??true,
                                      onTab: (){
                                        switch (filteredMenu[index].menuUrl) {
                                          case 'KHUTBA_MANAGEMENT':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => KhutbaListScreen()),
                                            );
                                            break;
                                          case 'NEW_MOSQUE':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new CreateMosque(),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'MOSQUE_EDIT_REQUEST':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new AllMosqueRequest(),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'MY_PROFILE':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new ProfileScreen(),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'CREATE_VISIT':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new CreateVisit(),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'ASSIGN_VISIT':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new AssignVisit(),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'TODAY_VISIT':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new TodayVisits(filter: this.menuRights!.searchVisit!.filter),
                                                //HalqaId: 1
                                              ),
                                            );
                                            break;
                                          case 'MOSQUES':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => new AllMosques(filter: this.menuRights!.mosqueList!.filter),
                                              //HalqaId: 1
                                            ),
                                          );
                                            break;
                                          case 'SURVEY_VISITS':
                                            final userProvider = Provider.of<UserProvider>(context, listen: false);

                                            if (userProvider.isDeviceVerify || Config.disableValidation) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SurveyVisitScreen(),
                                                ),
                                              );
                                            } else {
                                              Flushbar(
                                                icon: Icon(Icons.warning, color: Colors.white),
                                                backgroundColor: AppColors.danger,
                                                message: "device_not_unverified".tr(),
                                                duration: Duration(seconds: 3),
                                              ).show(context);
                                            }
                                            break;
                                          case 'MOSQUE_UTILITIES':
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const MosqueUtilitiesMenuScreen(),
                                              ),
                                            );
                                            break;
                                          default:
                                            print('');
                                        }

                                      }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
           bottomNavigationBar:BottomNavigation(selectedIndex: 1),
      ),
    );
  }
}
