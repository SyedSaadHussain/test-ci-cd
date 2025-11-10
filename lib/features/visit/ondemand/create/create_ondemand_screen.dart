import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/dashboard/visit_dashboard_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/create/create_ondemand_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/create/widget/visit_mosque_list.dart';
import 'package:mosque_management_system/features/visit/ondemand/create/widget/visit_observer_list.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/service_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_model_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

class CreateOndemandScreen extends StatefulWidget {
  const CreateOndemandScreen({super.key});

  @override
  _CreateOndemandScreenState createState() => _CreateOndemandScreenState();
}

class _CreateOndemandScreenState extends BaseState<CreateOndemandScreen> {

  final vm = VisitDashboardViewModel();
  @override
  void initState() {
    super.initState();

  }


  @override
  void widgetInitialized() {
    super.widgetInitialized();
    final vm = context.read<CreateOndemandViewModel>();
    vm.visitRepository = VisitRepository();
    vm.showDialogCallback=((DialogMessage dialogMessage){
      if (!mounted) return;
      AppNotifier.showDialog(context,dialogMessage);
    });
    vm.init();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CreateOndemandViewModel>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title:   Text(VisitMessages.createVisit),
        ),
        body:   Stack(
          children: [
            Column(
              children: [
                Selector<CreateOndemandViewModel, int?>(
                    selector: (_, vm) => vm.fields.list.length,
                    builder: (_, __, ___) {
                    return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Form(
                          key: vm.formKey,
                          child: Column(

                            children: [
                              Selector<CreateOndemandViewModel, String?>(
                                  selector: (_, vm) => vm.visit.mosque,
                                  builder: (_, __, ___) {
                                    return AppModelField(
                                      isRequired: true,
                                      title: vm.fields.getField('mosque_id').label,
                                      value: vm.visit.mosque,
                                      list: VisitMosqueList(title:vm.fields.getField('mosque_id').label,onItemTap: (ComboItem item){
                                        vm.updateMosque(item);
                                      },visitService: vm.visitRepository,),
                                    );
                                  }
                              ),
                              Selector<CreateOndemandViewModel, String?>(
                                  selector: (_, vm) => vm.visit.employee,
                                  builder: (_, __, ___) {
                                    return AppModelField(
                                      isRequired: true,
                                      title: vm.fields.getField('employee_id').label,
                                      value: vm.visit.employee,
                                      list: VisitObserverList(title: vm.fields.getField('employee_id').label,onItemTap: (ComboItem item){
                                        vm.updateObserver(item);
                                      },visitService: vm.visitRepository,),
                                    );
                                  }
                              ),
                              AppDateField(
                                title: vm.fields.getField('deadline_date').label,
                                isRequired: true,
                                onChanged: (val){
                                  vm.visit.deadlineDate=val;
                                },
                              ),
                              AppSelectionField(
                                title: vm.fields.getField('prayer_name').label,
                                options: vm.fields.getComboList('prayer_name'),
                                value: vm.visit.prayerName,
                                onChanged: (val){
                                  vm.visit.prayerName=val;
                                },
                              ),
                              SizedBox(height: 15,),
                              AppButton(
                                  text: VisitMessages.submit,
                                  color: AppColors.primary,
                                  onTab: (){

                                    vm.onSubmit(context);

                                  }
                              )
                            ],
                          ),
                        ));
                  }
                )
              ],
            ),
            Selector<CreateOndemandViewModel, bool>(
              selector: (_, vm) => vm.isLoading,
              builder: (_, isLoading, __) {
                if (isLoading)
                  return ProgressBar();
                else
                  return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
