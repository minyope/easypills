import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ⚠️ 실제 맵을 위해선 이 패키지를 설치해야 합니다.

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 지도의 초기 카메라 위치 (예: 서울 시청)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도 화면'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFFD4755),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 맵 위젯 (실제 구현 시 여기에 GoogleMap 위젯을 사용합니다.)
          const Center(child: Text("실제 GoogleMap 위젯이 여기에 표시됩니다.")),

          // 검색 및 주변 장소 찾기 기능을 위한 UI (상단)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '장소 검색 (예: 약국, 병원)',
                  suffixIcon: Icon(Icons.search, color: Color(0xFFFD4755)),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (query) {
                  // 여기에 장소 검색 로직을 호출합니다. (3단계 참고)
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
