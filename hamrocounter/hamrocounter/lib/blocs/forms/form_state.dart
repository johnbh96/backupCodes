part of 'form_bloc.dart';

abstract class FormState extends Equatable {

  const FormState();

  @override
  List<Object?> get props => []; 
}

class FormReady extends FormState {

  const FormReady();

  @override
  List<Object?> get props => [];
}

class SubmitInProgress extends FormState {

  const SubmitInProgress();

  @override
  List<Object?> get props => [];
}

class SubmitFailed extends FormState {

  final String message;

  const SubmitFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class SubmitSuccess<T> extends FormState {

  final T data;

  const SubmitSuccess(this.data);

  @override
  List<Object?> get props => [data];
}
