part of 'signup_bloc.dart';

@immutable
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupBlocFailure extends SignupState {
  final String errorMessage;
  const SignupBlocFailure(this.errorMessage);
}

class SignupSuccessState extends SignupState {
  final LoginSuccessResponse signupResponse;
  const SignupSuccessState(this.signupResponse);
}
