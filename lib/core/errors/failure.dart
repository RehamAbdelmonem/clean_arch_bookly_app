import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServce');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServce');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServce');

      case DioExceptionType.badCertificate:
        //
        return ServerFailure('Incorrect Certificate');

      case DioExceptionType.badResponse:
        return ServerFailure.fromRespone(
            e.response!.statusCode, e.response!.data);

      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServce was canceld');

      case DioExceptionType.connectionError:
        return ServerFailure('No Internet Connection, please try later!');

      case DioExceptionType.unknown:
        // if (e.message!.contains('SocketException')) {
        //   return ServerFailure('No Internet Connection');
        // }
        // return ServerFailure('Unexpected Error, please try again!');
        // default:
        return ServerFailure('Opps There was an Error, please try again');
    }
  }

  factory ServerFailure.fromRespone(int? statusCode, dynamic response) {
    if (statusCode == 404) {
      return ServerFailure('Your request not found, please try later!');
    } else if (statusCode == 500) {
      return ServerFailure('There is a problem with a server, please try later');
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else {
      return ServerFailure('Opps There was an Error, please try again');
    }
  }
}
