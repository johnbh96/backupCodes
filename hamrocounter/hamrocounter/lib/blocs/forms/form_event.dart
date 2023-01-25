part of 'form_bloc.dart';

abstract class FormAction extends Equatable {

  const FormAction();

  @override
  List<Object?> get props => [];
}

class SubmitForm extends FormAction {
  const SubmitForm();

  @override
  List<Object?> get props => [];
}