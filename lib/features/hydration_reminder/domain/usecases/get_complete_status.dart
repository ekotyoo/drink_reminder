import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class GetCompleteStatus {
  final HydrationRepository repository;

  GetCompleteStatus(this.repository);

  Future<Either<Failure, bool>> excecute() {
    return repository.getCompleteStatus();
  }
}
