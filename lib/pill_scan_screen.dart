import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // 패키지 추가 필요

const Color primaryColor = Color(0xFFFD4755);

// 요청하신 대로 'longCircle' 제거
enum PillShape { circle, halfMoon, triangle }

class PillScanScreen extends StatefulWidget {
  const PillScanScreen({super.key});

  @override
  State<PillScanScreen> createState() => _PillScanScreenState();
}

class _PillScanScreenState extends State<PillScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  PillShape _selectedShape = PillShape.circle;
  String _scanResult = "알약 모양을 선택하고 스캔 버튼을 눌러주세요.";
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // 앱 시작 시 카메라 초기화
  }

  // 카메라 초기화 함수
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0], // 후면 카메라
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // 메모리 해제
    super.dispose();
  }

  // 모양별 가이드 아이콘/테두리
  IconData _getIconForShape(PillShape shape) {
    switch (shape) {
      case PillShape.circle:
        return Icons.circle_outlined;
      case PillShape.halfMoon:
        return Icons.water_drop_outlined;
      case PillShape.triangle:
        return Icons.change_history_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // 모양 선택 버튼 위젯
  Widget _buildShapeButton(PillShape shape) {
    final bool isSelected = _selectedShape == shape;
    String shapeName = shape == PillShape.circle
        ? '동그라미'
        : (shape == PillShape.halfMoon ? '반달모양' : '세모');

    return GestureDetector(
      onTap: () => setState(() => _selectedShape = shape),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getIconForShape(shape),
              color: isSelected ? primaryColor : Colors.grey,
            ),
            Text(
              shapeName,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 촬영 버튼 로직
  void _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture(); // 사진 촬영
      setState(() {
        _scanResult = "사진 분석 중... (경로: ${image.path})";
      });

      // 서버 연동 시 여기서 image.path를 서버로 전송합니다.
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _scanResult = "[스캔 결과]\n- 약품명: 타이레놀 500mg\n- 효능: 해열 진통";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 알약 스캔'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // 1. 모양 선택
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: PillShape.values.map(_buildShapeButton).toList(),
            ),
          ),

          // 2. 카메라 미리보기 + 가이드 가이드 테두리(Overlay)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: _isCameraInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_controller!), // 실제 카메라 화면
                        // ✨ 가이드 테두리 (Overlay)
                        Opacity(
                          opacity: 0.5,
                          child: Icon(
                            _getIconForShape(_selectedShape),
                            size: 200,
                            color: Colors.white,
                          ),
                        ),

                        // 안내 문구
                        Positioned(
                          bottom: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            color: Colors.black54,
                            child: const Text(
                              '가이드 라인에 알약을 맞춰주세요',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // 3. 촬영 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('촬영 및 분석'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 55),
                foregroundColor: Colors.white,
              ),
            ),
          ),

          // 4. 결과창
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Text(
              _scanResult,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
