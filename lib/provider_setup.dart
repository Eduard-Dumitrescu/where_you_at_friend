import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whereyouatfriend/DeviceCache/SharedPreferences/shared_preference_repo.dart';
import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => Firestore.instance),
  Provider(create: (_) => SharedPreferenceRepo()),
  Provider(create: (_) => CitizenService())
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
];
