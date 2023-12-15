import 'package:dartz/dartz.dart';
import 'package:flutter_hive_tdo/data/models/common/api_error_model.dart';

abstract class TaskRepository {
  Future<Either<Task, APIError>> create(Task taskRequest);
}
