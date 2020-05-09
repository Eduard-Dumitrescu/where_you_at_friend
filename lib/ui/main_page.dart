import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    var citizenService = Provider.of<CitizenRepo>(context);
    Geolocator()
        .placemarkFromAddress("Zorilor street, Romania")
        .then((placemark) {
      var a = placemark;
      var b = 2;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Where you at buddy"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: citizenService.getAllCitizensAsStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return Container();
            Iterable<Citizen> citizenList = snapshot.data;

            return snapshot.hasData
                ? ListView.builder(
                    itemCount: citizenList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          "name: ${citizenList.elementAt(index).id} postalCode: ${citizenList.elementAt(index).postalCode} status: ${citizenList.elementAt(index).status}");
                    },
                  )
                : Container();
          },
        ),
        // ,
      ),
    );
  }
}
