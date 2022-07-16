part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpApiEvent extends SignUpEvent {
  final Map<String, dynamic> params;

  SignUpApiEvent(this.params);
}
