import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whereyouatfriend/models/citizen.dart';

class CitizenService {
  Firestore _firestore;

  CitizenService(this._firestore);

  Stream<Iterable<Citizen>> getCitizens() =>
      _firestore.collection("citizens").snapshots().map((data) =>
          data.documents.map((docData) => Citizen.fromMap(docData.data)));
}
