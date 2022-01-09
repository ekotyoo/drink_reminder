import 'package:dartz/dartz.dart';
import 'package:drink_reminder/core/error/failure.dart';
import 'package:drink_reminder/features/hydration_reminder/domain/repositories/hydration_repository.dart';

class InsertOrUpdateCompleteStatus {
  final HydrationRepository repository;

  InsertOrUpdateCompleteStatus(this.repository);

  Future<Either<Failure, void>> execute(bool value) async {
    return repository.updateCompleteStatus(value);
  }
}
