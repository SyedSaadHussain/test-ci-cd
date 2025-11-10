class PaginatedList<T> {


  PaginatedList({isLoading});
  String field='';
  List<T> list=[];
  int pageIndex=0;
  int pageSize=10;
  bool hasMore=true;
  bool isLoading=false;
  int count=0;

  bool get noRecord =>  hasMore==false && list.length==0;

  reset(){
    pageIndex=1;
    list=[];
    count=0;
  }
  init(){
    hasMore=true;
    isLoading=true;
  }
  finish(){
    hasMore=false;
    isLoading=false;
  }
}