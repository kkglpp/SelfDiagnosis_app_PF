// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//출처
//https://parkjh7764.tistory.com/205

class GpsShow extends StatefulWidget {
  const GpsShow({super.key});

  @override
  State<GpsShow> createState() => _GpsShowState();
}

class _GpsShowState extends State<GpsShow> {

  final _markers = <Marker>{};

  static final LatLng schoolLatlng = LatLng(
    //위도와 경도 값 지정
    37.494714,
    127.030067,
  );


  static final CameraPosition initialPosition = CameraPosition(
    //지도를 바라보는 카메라 위치
    target: schoolLatlng, //카메라 위치(위도, 경도)
    zoom: 18, //확대 정도
  );

      final _hosiptals = [
  {
    "name": "강남메이퓨어의원",
    "latitude": 37.494445,
    "longitude": 127.030635,
  },
  {
    "name": "노들담한의원 강남",
    "latitude": 37.494863,
    "longitude": 127.030352,
  },
  {
    "name": "강남이룸안과의원",
    "latitude": 37.495034,
    "longitude": 127.029769,
  },
  {
    "name": "연세퍼스트구강내과치과의원",
    "latitude": 37.494594,
    "longitude": 127.029733,
  },
  ];


  @override
  void initState() {
    super.initState();
    getCurrentLocation();



    _markers.addAll(
    _hosiptals.map(
      (e) => Marker(
        markerId: MarkerId(e['name'] as String),
        infoWindow: InfoWindow(title: e['name'] as String),
        position: LatLng(
          e['latitude'] as double,
          e['longitude'] as double,
        ),
      ),
    ),
  );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 주변 병원 찾기',
          style:
              TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        //구글 맵 사용
        mapType: MapType.normal, //지도 유형 설정
        initialCameraPosition: initialPosition, //지도 초기 위치 설정
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }


   Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
        print(position.latitude);
        print(position.longitude);

    return position;
  }
}