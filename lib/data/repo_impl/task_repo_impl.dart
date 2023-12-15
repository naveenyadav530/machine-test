import 'package:dartz/dartz.dart';
import 'package:flutter_hive_tdo/data/models/common/api_error_model.dart';

import '../../domain/repository/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl();

  // @override
  // Future<Either<CommonResponse, APIError>> generateToken(param) async {
  //   try {
  //     var changePasswordResponse =
  //         await _dio.post(Apis.refreshToken, data: param);
  //     return Left(
  //       CommonResponse.fromJson(
  //         changePasswordResponse.data,
  //       ),
  //     );
  //   } on DioError catch (e) {
  //     return ServerError.handleError(e).then(
  //       (value) => Right(
  //         APIError(message: value, code: e.response?.statusCode ?? 0),
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     return Right(APIError(message: e.toString(), code: 0));
  //   }
  // }

  @override
  Future<Either<Task, APIError>> create(Task taskRequest) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
