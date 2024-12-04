part of 'todos_bloc.dart';

sealed class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

final class TodosLoadingState extends TodosState {}

final class TodosLoadedState extends TodosState {
  final List<Todos> todo;

  const TodosLoadedState({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}

final class TodoErrorState extends TodosState {
  final String errorMessage;
  const TodoErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}