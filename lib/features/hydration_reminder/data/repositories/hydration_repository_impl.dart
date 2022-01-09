import 'package:drink_reminder/core/error/exception.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:drink_reminder/features/hydration_reminder/data/datasources/hydration_local_datasource.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class HydrationRepositoryImpl extends HydrationRepository {
  final HydrationLocalDatasource localDatasource;

  HydrationRepositoryImpl(this.localDatasource);
  @override
  Future<Either<Failure, void>> cacheHydration(int value) async {
    try {
      await localDatasource.insertOrUpdateHydration(value);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHydrationCache() async {
    try {
      await localDatasource.deleteHydration();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentHydration() async {
    try {
      final result = await localDatasource.getHydration();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateHydration(int value) async {
    try {
      await localDatasource.insertOrUpdateHydration(value);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getCompleteStatus() async {
    try {
      final result = await localDatasource.getCompleteStatus();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> insertOrUpdateCompleteStatus(bool value) async {
    try {
      await localDatasource.insertOrUpdateCompleteStatus(value);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
