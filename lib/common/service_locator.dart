import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_history/presentation/providers/hydration_history_change_notifier.dart';
import 'package:drink_reminder/features/hydration_reminder/data/datasources/hydration_local_datasource.dart';
import 'package:drink_reminder/features/hydration_reminder/data/repositories/hydration_repository_impl.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/delete_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/get_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/usecases/insert_or_update_hydration.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_change_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

final locator = GetIt.instance;

void init() {
  //providers
  locator.registerFactory(
      () => HydrationChangeNotifier(locator(), locator(), locator()));
  locator.registerFactory(() => HydrationHistoryChangeNotifier());
  locator.registerFactory(() => ThemeChangeNotifier());

  //usecases
  locator.registerLazySingleton(() => InsertOrUpdateHydration(locator()));
  locator.registerLazySingleton(() => GetHydration(locator()));
  locator.registerLazySingleton(() => DeleteHydration(locator()));

  //repositories
  locator.registerLazySingleton<HydrationRepository>(
      () => HydrationRepositoryImpl(locator()));

  //datasources
  locator.registerLazySingleton<HydrationLocalDatasource>(
      () => HydrationLocalDatasourceImpl(locator(), locator()));

  //helpers
  locator.registerLazySingleton(() => DatabaseHelper.instance);

  // others
  locator.registerLazySingleton(() => GetStorage());
}
