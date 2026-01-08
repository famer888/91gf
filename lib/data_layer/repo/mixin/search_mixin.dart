part of '../repo.dart';

mixin _Search on _BaseAppRepo implements SearchDomain {

 @override
 AsyncResult<SearchModel> searchHotList() =>
     _searchService.searchHotList().deserializeJsonBy(SearchModel.fromJson).guard;
}
