import 'package:dartz/dartz.dart';
import 'package:flutter_hive_tdo/data/models/common/api_error_model.dart';
import 'package:flutter_hive_tdo/domain/repository/task_repository.dart';
import 'package:flutter_hive_tdo/domain/usecases/base_api_usecase.dart';

class LoginUseCase with BaseApiUseCase {
  final TaskRepository taskRepository;

  LoginUseCase({
    required TaskRepository loginRepository,
  }) : taskRepository = loginRepository;

  @override
  Future<Either<Task, APIError>> call(params) {
    return taskRepository.create(params);
  }
}
