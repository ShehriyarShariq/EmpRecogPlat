part of 'credentials_bloc.dart';

abstract class CredentialsState extends Equatable {
  const CredentialsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends CredentialsState {}

class Processing extends CredentialsState {}

class Success extends CredentialsState {
  final bool isAdmin;

  Success({this.isAdmin}) : super([isAdmin]);
}

class Registered extends CredentialsState {}

class Error extends CredentialsState {
  final String errorMessage;

  Error(this.errorMessage);
}
