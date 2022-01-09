import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';

abstract class HydrationRepository {
  // Hydration
  Future<Either<Failure, void>> cacheHydration(int value);
  Future<Either<Failure, void>> deleteHydrationCache();
  Future<Either<Failure, void>> updateHydration(int value);
  Future<Either<Failure, int>> getCurrentHydration();

  // Complete Status
  Future<Either<Failure, void>> insertOrUpdateCompleteStatus(bool value);
  Future<Either<Failure, bool>> getCompleteStatus();
}
