import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class GetHydration {
  final HydrationRepository repository;

  GetHydration(this.repository);
  Future<Either<Failure, int>> execute(int value) {
    return repository.getCurrentHydration();
  }
}
