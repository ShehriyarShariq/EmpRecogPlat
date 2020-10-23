import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthParams extends Equatable {
  final dynamic userCred;

  AuthParams({@required this.userCred});

  @override
  List<Object> get props => [userCred];
}