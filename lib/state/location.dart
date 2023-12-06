import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:location/location.dart';

part 'location.g.dart';

@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  Future<LocationData?> build() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return null;
      }
    }

    if (await location.hasPermission() == PermissionStatus.denied) {
      if (await location.requestPermission() != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}