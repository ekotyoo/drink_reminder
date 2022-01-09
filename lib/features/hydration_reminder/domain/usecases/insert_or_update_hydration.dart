import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class InsertOrUpdateHydration {
  final HydrationRepository repository;

  const InsertOrUpdateHydration(this.repository);

  Future<Either<Failure, void>> execute(int value) {
    return repository.cacheHydration(value);
  }
}
