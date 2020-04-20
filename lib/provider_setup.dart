import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => Firestore.instance)
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Firestore, CitizenService>(
    update: (context, firestore, citizenService) => CitizenService(firestore),
  ),
  ProxyProvider<CitizenService, CitizenRepo>(
    update: (context, citizenService, citizenRepo) =>
        CitizenRepo(citizenService),
  )
];
