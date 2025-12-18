import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // http 패키지 추가

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  // ✨ 검색된 약국 마커들을 저장할 Set
  final Set<Marker> _markers = {};

  // ✨ 제공해주신 구글 API 키
  final String googleApiKey = "AIzaSyDoc_UY9terJO1Fnn4kWnjC9BpCvRiYdnI";

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // [기능 1] 현재 위치 권한 확인 및 지도 이동
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    // 카메라 이동
    _moveCamera(currentLatLng);

    // ✨ 현재 위치를 찾은 후 자동으로 약국 검색 실행
    _searchPharmacy(currentLatLng);
  }

  // ✨ [기능 2] Google Places API를 이용한 주변 약국 검색
  Future<void> _searchPharmacy(LatLng location) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${location.latitude},${location.longitude}'
        '&radius=1500' // 반경 1.5km 이내
        '&type=pharmacy' // 검색 타입: 약국
        '&language=ko' // 한국어 결과
        '&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        setState(() {
          _markers.clear(); // 기존 마커 초기화
          for (var place in results) {
            final lat = place['geometry']['location']['lat'];
            final lng = place['geometry']['location']['lng'];
            final String name = place['name'];
            final String address = place['vicinity'] ?? "";

            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: name, snippet: address),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      print("약국 검색 중 오류 발생: $e");
    }
  }

  void _moveCamera(LatLng target) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15.5),
      ),
    );
  }

  // 검색창에서 수동 검색 시 로직 (검색어로 검색)
  void _searchLocation(String query) async {
    // 텍스트 검색 API 등을 활용할 수 있으나, 여기서는 입력 후
    // 현재 지도 중앙 좌표 기준으로 다시 약국 검색을 하도록 응용 가능합니다.
    Position position = await Geolocator.getCurrentPosition();
    _searchPharmacy(LatLng(position.latitude, position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주변 약국 찾기'),
        backgroundColor: const Color(0xFFFD4755),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers, // ✨ 검색된 마커들을 지도에 표시
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          // 상단 검색창
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '장소 검색 (예: 약국, 병원)',
                    suffixIcon: Icon(Icons.search, color: Color(0xFFFD4755)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) => _searchLocation(query),
                ),
              ),
            ),
          ),

          // 내 위치 버튼
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location, color: Color(0xFFFD4755)),
            ),
          ),
        ],
      ),
    );
  }
}
