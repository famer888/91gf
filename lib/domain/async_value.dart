import 'package:freezed_annotation/freezed_annotation.dart';
part 'async_value.freezed.dart';

@Freezed(
  when: FreezedWhenOptions(when: true, whenOrNull: true, maybeWhen: true),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: false),
)
class AsyncValue<T> with _$AsyncValue<T> {
  const factory AsyncValue.init() = AsyncInit;
  const factory AsyncValue.data(T value) = AsyncData<T>;
  const factory AsyncValue.loading({T? value}) = AsyncLoading<T>;
  const factory AsyncValue.error({Object? error, StackTrace? stackTrace}) =
      AsyncError;
}

extension AsyncValueHelper<T> on AsyncValue<T> {
  bool get isLoading => this is AsyncLoading;

  T? get data => maybeWhen(
        data: (data) => data,
        loading: (data) => data,
        orElse: () => null,
      );
}
