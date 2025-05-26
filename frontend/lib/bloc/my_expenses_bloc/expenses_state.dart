import 'package:frontend/models/expenses_model.dart';

abstract class ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;

  ExpensesLoaded(this.expenses);
}
