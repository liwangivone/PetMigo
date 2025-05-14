import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';


//Model
import 'package:frontend/models/model_login.dart';

//BLoC
import 'package:frontend/bloc/login_bloc.dart';

//Tampilan
part 'splash_screen.dart';
part 'onboarding_pages.dart';
part 'register_page.dart';
part 'login_page.dart';
part 'tnc_page.dart';
part 'home_page.dart';