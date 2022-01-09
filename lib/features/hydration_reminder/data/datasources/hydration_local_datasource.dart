import 'package:drink_reminder/common/db_helper.dart';
import 'package:drink_reminder/core/error/exception.dart';
import 'package:get_storage/get_storage.dart';

abstract class HydrationLocalDatasource {
  Future<void> insertOrUpdateHydration(int value);
  Future<void> deleteHydration();
  Future<int> getHydration();
}

class HydrationLocalDatasourceImpl extends HydrationLocalDatasource {
  final DatabaseHelper database;
  final GetStorage cacheStorage;

  HydrationLocalDatasourceImpl(this.database, this.cacheStorage);

  @override
  Future<void> deleteHydration() async {
    try {
      await cacheStorage.write('current_drink', 0);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<int> getHydration() async {
    try {
      final result = await cacheStorage.read('current_drink');
      return result;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> insertOrUpdateHydration(int value) async {
    try {
      await cacheStorage.write('current_drink', value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
