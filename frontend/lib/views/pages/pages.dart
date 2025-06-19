// ────── FLUTTER CORE ──────
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ────── BLOC ──────
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/bloc/onboarding_bloc.dart';
import 'package:frontend/bloc/regist_bloc.dart';

import 'package:frontend/bloc/pet/pet_bloc.dart';
import 'package:frontend/bloc/pet/pet_event.dart';
import 'package:frontend/bloc/pet/pet_state.dart';

import 'package:frontend/bloc/petschedule/pet_schedule_bloc.dart';
import 'package:frontend/bloc/petschedule/pet_schedule_event.dart';
import 'package:frontend/bloc/petschedule/pet_schedule_state.dart';

import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/bloc/user/user_event.dart';
import 'package:frontend/bloc/user/user_state.dart';

import 'package:frontend/bloc/clinic/clinic_bloc.dart';
import 'package:frontend/bloc/clinic/clinic_event.dart';
import 'package:frontend/bloc/clinic/clinic_state.dart';

import 'package:frontend/bloc/vet/vet_bloc.dart';
import 'package:frontend/bloc/vet/vet_event.dart';
import 'package:frontend/bloc/vet/vet_state.dart';

import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/bloc/chat/chat_event.dart';
import 'package:frontend/bloc/chat/chat_state.dart';

// ────── MODELS ──────
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/vet_model.dart';
import 'package:frontend/models/pet_model.dart';
import 'package:frontend/models/clinic_model.dart';
import 'package:frontend/models/chat_model.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/petschedules_model.dart';

// ────── SERVICES ──────
import 'package:frontend/services/user_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:frontend/services/vet_service.dart';
import 'package:frontend/services/clinic_service.dart';
import 'package:frontend/services/chat_service.dart';  // ⬅️ tambahkan ini

// ────── REPOSITORY ──────
import 'package:frontend/repository/auth_repository.dart';
import 'package:frontend/repository/user_repository.dart';
import 'package:frontend/repository/pet_repository.dart';
import 'package:frontend/repository/vet_repository.dart';
import 'package:frontend/repository/clinic_repository.dart';
import 'package:frontend/repository/chat_repository.dart'; // ⬅️ cukup sekali, hapus duplikat

// ────── THIRD PARTY ──────
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ────── WIDGETS ──────
import 'package:frontend/widget/chat_card.dart';

// ────── VIEWS (Split using 'part') ──────
part 'splash_screen.dart';
part 'onboarding_pages.dart';
part 'register_page.dart';
part 'login_page.dart';
part 'tnc_page.dart';
part 'home_page.dart';
part 'profile_page.dart';
part 'askAI_page.dart';
part 'my_expenses_page.dart';
part 'bottom_navbar.dart';
part 'add_new_pet.dart';
part 'vets_list_page.dart';
part 'vet_detail_page.dart';
part 'vet_dashboard_page.dart';
part 'vet_chat_list_page.dart';
part 'pet_detail_page.dart';
part 'edit_pet_form.dart';
part 'vet_login_page.dart';
part 'vet_register_page.dart';
part 'choose_login.dart';
part 'vet_home_page.dart';
part 'add_petschedule_pet.dart';