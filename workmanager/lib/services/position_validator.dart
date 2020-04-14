
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class PositionValidator {
//todo remplacer par le plugin location
  static Geolocator geolocator = Geolocator()..forceAndroidLocationManager= true;


  Future<bool> checkIfLocationPermission() async{
    bool result;
    geolocator = Geolocator()..forceAndroidLocationManager= true;

try {
  await geolocator.checkGeolocationPermissionStatus().then((value) async {
    if (value == GeolocationStatus.granted)
      result = true;
    else {
      result = false;
      await Permission.locationWhenInUse.request().then((value) {
        if (value != PermissionStatus.granted)
          result = false;
        else
          result = true;
      });
    }
  });
  return result;
}catch(e){
  print(e);
  return result;
}
  }

  Future<bool> checkIfLocationIsNearEnough(String address) async {

    double distanceBetween;
    Position employeeCurrentPosition;
    try {
      List<Placemark> employerAddress = await geolocator.placemarkFromAddress(
          address);

      await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((pos) {
        employeeCurrentPosition = pos;
        print(pos);
      });

      distanceBetween= await Geolocator().distanceBetween(employeeCurrentPosition.latitude, employeeCurrentPosition.longitude, employerAddress[0].position.latitude, employerAddress[0].position.longitude);
      print("DISTANCE $distanceBetween");
      print(employerAddress[0].position.latitude);
      if(distanceBetween < 50.0)  // l'employé est trop loin du domicile de l'employeur à plus de 50 m
        return true;
      else
        return false;
    }catch(e){
      print(e);
      print("the provided address( address of the employer) is wrong");
      return false;
    }


  }
}

/*class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) Text(_currentAddress),
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                // Get location here
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }*/
/*  _getCurrentLocation() async{
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager= true;

    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    print("STATUS $geolocationStatus");

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();

    }).catchError((e) {
      print(e);
    });
    List<Placemark> placemark1 = await Geolocator().placemarkFromAddress("10 rue de la bassee 59000 Lille");
    List<Placemark> placemark2 = await Geolocator().placemarkFromAddress("1 Boulevard Bigo Danel, 59000 Lille");
    double distance= await geolocator.distanceBetween(placemark1[0].position.latitude, placemark1[0].position.longitude, placemark2[0].position.latitude, placemark2[0].position.longitude);
    print("distance $distance");
    print(placemark1[0].position);
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }*/


