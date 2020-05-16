import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/viewmodels/main_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainViewModel _mainViewModel;

  @override
  void initState() {
    super.initState();
    _mainViewModel = Provider.of<MainViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Where you at buddy"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ValueListenableBuilder<String>(
                valueListenable: _mainViewModel.shownZone,
                builder: (context, zone, _) =>
                    zone.isNotEmpty ? Text(zone) : Container(),
              ),
            ),
            Flexible(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: FutureBuilder<CameraPosition>(
                      future: _mainViewModel.getCitizenPosition(),
                      builder: (context, cameraPosition) {
                        return cameraPosition.hasData
                            ? GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: cameraPosition.data,
                                onMapCreated: (GoogleMapController controller) {
                                  _mainViewModel.mapsController
                                      .complete(controller);
                                },
                                onCameraMove: (cameraPosition) async =>
                                    _mainViewModel.changeZone(cameraPosition),
                                onCameraIdle: () => _mainViewModel.updateZone(),
                              )
                            : Container();
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mainViewModel.cleanup();
  }
}
