import 'package:dartz/dartz.dart';
import 'package:flutter_hive_tdo/data/models/common/api_error_model.dart';

mixin BaseApiUseCase<Response, Params> {
  Future<Either<Response, APIError>> call(Params params);
}
