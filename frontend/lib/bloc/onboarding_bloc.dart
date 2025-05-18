import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int page;

  OnboardingPageChanged(this.page);
}

class OnboardingNextPressed extends OnboardingEvent {}


class OnboardingState {
  final int currentPage;

  OnboardingState({required this.currentPage});

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }
}



class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int totalPages;

  OnboardingBloc({required this.totalPages}) : super(OnboardingState(currentPage: 0)) {
    on<OnboardingPageChanged>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    on<OnboardingNextPressed>((event, emit) {
      if (state.currentPage < totalPages - 1) {
        emit(state.copyWith(currentPage: state.currentPage + 1));
      }
    });
  }
}