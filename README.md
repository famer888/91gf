# jygf

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# 添加 model进 lib/domain/create_export_domains.dart  dart lib/domain/create_export_domains.dart
# 添加 image文件进 image_paths.dart  dart lib/images_to_dart.dart

# 生成.g.dart文件：fvm flutter pub run build_runner build 或者  fvm flutter pub run build_runner watch

# 脚本执行生成文件并删除前后的冲突 flutter pub run build_runner build --delete-conflicting-outputs

# 打包，先fvm切换flutter sdk到匹配版本
# 打包apk 执行 fvm flutter build apk --obfuscate --split-debug-info=HLQ_Struggle
# 打包web 执行
# 升级版本号
fvm flutter build web --web-renderer html --release
fvm dart add_version.dart
# apk 名称格式 包名_版本号_时间戳.apk