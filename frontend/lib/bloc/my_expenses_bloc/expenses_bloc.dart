import 'package:flutter_bloc/flutter_bloc.dart';
import 'expenses_event.dart';
import 'expenses_state.dart';
import 'package:frontend/models/expenses_model.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesLoading()) {
    on<LoadExpenses>((event, emit) async {
      // Dummy data
      await Future.delayed(Duration(milliseconds: 300));
      emit(ExpensesLoaded([
        Expense("Vaccination", "Molly", 150000, "2025-04-20", "15:45", "Vaccination"),
        Expense("Grooming", "Henry", 150000, "2025-04-20", "13:00", "Grooming"),
        Expense("Grooming", "Henry", 60000, "2025-04-19", "11:00", "Grooming"),
      ]));
    });
  }
}
