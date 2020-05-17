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
      appBar: _appBar(),
      body: _mainBody(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: const Text("Where you at buddy"),
    );
  }

  Widget _mainBody() {
    return Container(
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
          Flexible(
            child: ZoneDataWidget(_mainViewModel),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mainViewModel.cleanup();
  }
}

class ZoneDataWidget extends StatelessWidget {
  final MainViewModel _mainViewModel;
  const ZoneDataWidget(this._mainViewModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: ValueListenableBuilder<bool>(
              valueListenable: _mainViewModel.isInside,
              builder: (context, isInside, _) => Switch(
                value: isInside,
                onChanged: (value) => _mainViewModel.updateIsInside(value),
              ),
            ),
          ),
          Flexible(
            child: RaisedButton(
              onPressed: () async => _mainViewModel.updateZoneData(),
              child: const Text("Refresh"),
            ),
          ),
          Flexible(
            child: ValueListenableBuilder<String>(
              valueListenable: _mainViewModel.currentZoneData,
              builder: (context, currentZoneData, _) =>
                  currentZoneData.isNotEmpty
                      ? Text(currentZoneData)
                      : Container(),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: const Text("People outside:"),
                      ),
                      Flexible(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _mainViewModel.citizensOutside,
                          builder: (context, citizensOutside, _) =>
                              Text(citizensOutside.toString()),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: const Text("People inside:"),
                      ),
                      Flexible(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _mainViewModel.citizensInside,
                          builder: (context, citizensInside, _) =>
                              Text(citizensInside.toString()),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ValueListenableBuilder<int>(
              valueListenable: _mainViewModel.citizensTotal,
              builder: (context, citizensTotal, _) => Text(
                  "Total registered citizens : ${citizensTotal.toString()}"),
            ),
          ),
        ],
      ),
    );
  }
}
