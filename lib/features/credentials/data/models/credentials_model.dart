import 'package:equatable/equatable.dart';

class CredentialsModel extends Equatable {
  final String empID, email, password;

  CredentialsModel({this.empID, this.email, this.password});

  @override
  // TODO: implement props
  List<Object> get props => [empID, email, password];
}
