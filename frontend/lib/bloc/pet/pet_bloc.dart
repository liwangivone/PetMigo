import 'package:flutter_bloc/flutter_bloc.dart';
import 'pet_event.dart';
import 'pet_state.dart';
import '../../services/pet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/pet_model.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetService petService;

  PetBloc(this.petService) : super(PetInitial()) {
    on<GetPetData>((event, emit) async {
      emit(PetLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userid') ?? '';

        if (userId.isEmpty) throw Exception('User ID not found');

        final petListJson = await petService.getPetsByUserId(userId);
        final pets = petListJson.map<Pet>((data) => Pet.fromJson(data)).toList();

        emit(PetLoaded(pets));
      } catch (e) {
        print("Error in PetBloc: $e");
        emit(PetError("Failed to load pet data"));
      }
    });
  }
}
