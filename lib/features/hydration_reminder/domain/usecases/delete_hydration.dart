import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class DeleteHydration {
  final HydrationRepository repository;

  const DeleteHydration(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.deleteHydrationCache();
  }
}
