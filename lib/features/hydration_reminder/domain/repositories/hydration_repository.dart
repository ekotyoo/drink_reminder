import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';

abstract class HydrationRepository {
  Future<Either<Failure, void>> cacheHydration(int value);
  Future<Either<Failure, void>> deleteHydrationCache();
  Future<Either<Failure, void>> updateHydration(int value);
  Future<Either<Failure, int>> getCurrentHydration();
}
