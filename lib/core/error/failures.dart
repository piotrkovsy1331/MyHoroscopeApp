import 'package:equatable/equatable.dart';

/// Domain-level description of what went wrong. The presentation layer
/// maps each subtype to a localized, user-friendly message.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class DataFormatFailure extends Failure {
  const DataFormatFailure();
}

final class CacheFailure extends Failure {
  const CacheFailure();
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}
