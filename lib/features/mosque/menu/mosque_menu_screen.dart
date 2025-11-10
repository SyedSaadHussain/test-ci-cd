import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/edit_request/list/all_mosque_edit_request.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/select_mosque_screen.dart';
import 'package:mosque_management_system/features/mosque/createMosque/list/mosque_detail_list.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/buttons/service_button.dart';

import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_icons.dart';
//import 'package:mosque_management_system/features/mosque/mosque_edit_req_list.dart'; // <— make sure this exists

class MosqueMenuScreen extends StatefulWidget {
  const MosqueMenuScreen({super.key});

  @override
  State<MosqueMenuScreen> createState() => _MosqueMenuScreenState();
}

class _MosqueMenuScreenState extends State<MosqueMenuScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider=context.read<UserProvider>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          /// 🔹 Header (mirrors VisitMenuScreen)
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    // Localize key if you have one; fallback provided
                    'mosque_menu'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),

          /// 🔹 Body Grid
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                padding: EdgeInsets.zero, // 👈 Removes the unwanted top gap
                children: [
                  ServiceButton(
                    text: 'create_mosque'.tr(), // add key or use 'All Mosques'
                    icon: AppIcons.mosque,
                    onTab: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<CreateMosqueBaseViewModel>(
                                create: (ctx) => CreateMosqueViewModel(mosqueObj: MosqueLocal(localId: 'local-${DateTime.now().millisecondsSinceEpoch}',),
                                service: MosqueRepository(),
                                  profile:userProvider.userProfile
                                ),
                                  child: CreateMosqueScreen(createIfMissing: true,),
                              ),
                        ),
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MosqueDetail(createIfMissing: true,), // <-- Update this import/class name if different
                      //   ),
                      // );
                    },
                  ),
                  //  All Mosques
                  ServiceButton(
                    text: 'all_mosques'.tr(), // add key or use 'All Mosques'
                    icon: AppIcons.mosque,
                    onTab: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MosqueDetailList()),
                      ); //132079
                    },
                  ),
                  ServiceButton(
                    text: 'mosque_edit_request'.tr(),
                    icon: AppIcons.draft,
                    onTab: () { // keep the same callback name your widget expects
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelectMosqueScreen(), // ✅ screen widget
                        ),
                      );
                    },
                  ),

                ServiceButton(
                text: 'all_mosque_edit_request'.tr(),
                  icon: AppIcons.draft,
                  onTab: () { // keep the same callback name your widget expects
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllMosqueEditRequestScreen(), // ✅ screen widget
                      ),
                    );
                  },
                ),

        ],
              ),
            ),
          ),
        ],
      ),
    );
  }

/// Small dialog to collect a Local ID, then open MosqueDetail
// Future<void> _promptAndOpenDetail(BuildContext context) async {
//   final controller = TextEditingController();
//   final ok = await showDialog<bool>(
//     context: context,
//     builder: (_) {
//       return AlertDialog(
//         title: Text('Enter Local ID'.tr()),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: 'e.g., 172987123'.tr(),
//             border: const OutlineInputBorder(),
//             isDense: true,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           ),
//           keyboardType: TextInputType.text,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text('Cancel'.tr()),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text('Open'.tr()),
//           ),
//         ],
//       );
//     },
//   );
//
//   if (ok == true) {
//     final id = controller.text.trim();
//     if (id.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid Local ID'.tr())),
//       );
//       return;
//     }
//     // Navigate to detail with provided localId
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => MosqueDetail(localId: id)),
//     );
//   }
// }
}