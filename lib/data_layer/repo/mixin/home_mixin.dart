part of '../repo.dart';

mixin _Home on _BaseAppRepo implements HomeDomain {
  @override
  AsyncResult<HomeData> getHomeConfig() => _homeService
          .getHomeConfig()
          .deserializeJsonBy(HomeData.fromJson)
          .then((value) async {
        if (value.data?.ads case final ads?
            when ads.imgUrl?.isNotEmpty == true) {
          await _cacheManager.upsertAds(ads);
        }
        if (value.data?.startScreenAds case final startScreenAds?) {
          await _cacheManager.upsertStartScreenAds(startScreenAds);
        }
        if (value.data?.config case final config?) {
          if (config.githubUrl case final url? when url.isNotEmpty) {
            await _cacheManager.upsertGithubUrl(url);
          }
          if (config.linesUrl case final lines? when lines.isNotEmpty) {
            await _cacheManager.upsertLinesUrl(lines);
          }
          if (config.officeSite case final url? when url.isNotEmpty) {
            await _cacheManager.upsertOfficeWeb(url);
          }
          if (config.buryPoint case final buryPoint) {
            AppGlobal.reportConfig = buryPoint;
            EventTracking.reportUrl = buryPoint.clickTransitPath;
            await _cacheManager.upsertReportAppId(buryPoint.clickAppId);
            AppGlobal.reportAppId = buryPoint.clickAppId;
          }          
          //seo设置
          if (kIsWeb) {
            final descTag = html.document.head!
                .querySelector('meta[name="description"]') as html.MetaElement?;
            final kwTag = html.document.head!
                .querySelector('meta[name="keywords"]') as html.MetaElement?;
            if (kwTag != null && descTag != null) {
              kwTag.content = config.keywords ?? "";
              descTag.content = config.description ?? "";
              html.document.title = config.title ?? "";
            }
          }
        }

        return value;
      }).guard;

  @override
  AsyncJson reqAdClickCount({int? id, int? type}) =>
      _homeService.reqAdClickCount(id: id ?? 0, type: type ?? 0);

  @override
  AsyncResult<AppCenterModel?> getAppCenter() => _homeService
      .getAppCenter()
      .deserializeJsonBy(AppCenterModel.fromJson)
      .guard;

  @override
  AsyncResult onExchange({required String cdk}) =>
      _homeService.onExchange(cdk: cdk).deserialize().guard;

  @override
  AsyncResult<OfficialGroupModel> getContactList() => _homeService
      .getContactList()
      .deserializeJsonBy(OfficialGroupModel.fromJson)
      .guard;
}
