part of '../repo.dart';

mixin _Search on _BaseAppRepo implements SearchDomain {
 @override
 @override
 AsyncResult<SearchModel> searchHotList() =>
     _searchService.searchHotList().deserializeJsonBy(SearchModel.fromJson).guard;
}
