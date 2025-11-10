import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';

class VisitMosqueList extends StatefulWidget {
  final Function onItemTap;
  final String? title;
  final VisitRepository? visitService;
  VisitMosqueList({required this.onItemTap,this.title,this.visitService});
  @override
  _VisitMosqueListState createState() => _VisitMosqueListState();
}

class _VisitMosqueListState extends State<VisitMosqueList> {
  ComboItemData data= ComboItemData();
  TextEditingController _controller = TextEditingController();
  List<String> items = [];
  List<String> filteredItems = [];

  @override
  void initState() {
    filteredItems.addAll(items);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    List<String> searchList = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      filteredItems.clear();
      filteredItems.addAll(searchList);
    });
  }
  void searchRecords(bool isReload){

    if(isReload){
      data.reset();
    }
    data.init();

    Future.delayed(const Duration(seconds: 0), () {
      widget.visitService!.getOndemandMosques(data.pageIndex,10,_controller.text).then((value){

        if(data.pageIndex>1){
          if(value.isEmpty){
            setState((){
              data.isloading=false;
              data.hasMore=false;
            });
          }else{
            setState((){
              data.list!.addAll(value.toList());
              data.isloading=false;
            });
          }

        }else{
          setState((){
            data.list=value;
            data.isloading=false;
          });
        }

      }).catchError((e){
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            onChanged: (val){
              setState(() {

              });
            },

            onSubmitted: (value) {
              searchRecords(true);
            },
            decoration: InputDecoration(
              hintText: 'search'.tr(),
              suffixIcon: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _controller.text.isEmpty
                        ?Container(): IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {

                        _controller.clear();
                        searchRecords(true);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        searchRecords(true);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(

            child: ListView.builder(
              itemCount: data.list!.length+((data.hasMore)?1:0),
              itemBuilder: (BuildContext context, int index) {
                if(index >= data.list!.length)
                {
                  data.pageIndex=data.pageIndex+1;
                  searchRecords(false);
                  return Container(
                      height: 100,
                      child: ProgressBar(opacity: 0));
                }
                else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 0),

                    decoration: BoxDecoration(
                      color:  index % 2 == 0 ? Colors.grey[100] : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100, // Change color as needed
                          width: 1.0, // Change thickness as needed
                        ),
                      ),
                    ),
                    child: ListTile(

                      title: Text(data.list[index].value??"",style: TextStyle(fontWeight: FontWeight.w300,color: AppColors.body),),

                      onTap: () {
                        this.widget.onItemTap(data.list[index]);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}