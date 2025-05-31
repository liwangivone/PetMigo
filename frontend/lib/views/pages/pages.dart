//Model
import 'package:flutter/services.dart';
import 'package:frontend/models/model_login.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/expenses_model.dart';
import 'package:frontend/models/vet_models.dart';

//BLoC
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/bloc/onboarding_bloc.dart';
import 'package:frontend/bloc/regist_bloc.dart';
import 'package:frontend/bloc/profile_bloc.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/bloc/my_expenses_bloc/expenses_bloc.dart';
import 'package:frontend/bloc/my_expenses_bloc/expenses_state.dart';
import 'package:frontend/bloc/my_expenses_bloc/expenses_event.dart';

//Dll
import 'package:pie_chart/pie_chart.dart';
import 'package:google_fonts/google_fonts.dart';

//Tampilan
part 'vets_list_page.dart';
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
part 'vet_detail_page.dart';


