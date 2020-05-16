import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whereyouatfriend/DeviceCache/SharedPreferences/shared_preference_repo.dart';
import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/repositories/zone_status_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';
import 'package:whereyouatfriend/services/zone_status_service.dart';
import 'package:whereyouatfriend/viewmodels/login_view_model.dart';
import 'package:whereyouatfriend/viewmodels/main_view_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...viewModelProviders
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => Firestore.instance),
  Provider(create: (_) => SharedPreferenceRepo()),
  Provider(create: (_) => CitizenService()),
  Provider(create: (_) => ZoneStatusService()),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<SharedPreferenceRepo, AuthState>(
    update: (context, sharedPreferenceRepo, authState) =>
        AuthState()..setSharedPreferenceRepo(sharedPreferenceRepo),
    create: (_) => AuthState(),
  ),
  ProxyProvider2<CitizenService, AuthState, CitizenRepo>(
    update: (context, citizenService, authState, citizenRepo) =>
        CitizenRepo(citizenService, authState),
  ),
  ProxyProvider2<ZoneStatusService, AuthState, ZoneStatusRepo>(
    update: (context, zonesStatusService, authState, zoneStatusRepo) =>
        ZoneStatusRepo(authState, zonesStatusService),
  ),
];

List<SingleChildWidget> viewModelProviders = [
  ProxyProvider<CitizenRepo, LoginViewModel>(
    update: (context, citizenRepo, loginViewModel) =>
        LoginViewModel(citizenRepo),
  ),
  ProxyProvider2<CitizenRepo, ZoneStatusRepo, MainViewModel>(
    update: (context, citizenRepo, zoneStatusRepo, mainViewModel) =>
        MainViewModel(citizenRepo, zoneStatusRepo),
  ),
];
