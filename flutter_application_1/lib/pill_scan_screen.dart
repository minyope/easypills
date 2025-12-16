import 'package:flutter/material.dart';

// 요청하신 통일 색상
const Color primaryColor = Color(0xFFFD4755);

// 알약 모양 정의를 위한 Enum
enum PillShape { circle, halfMoon, triangle, longCircle }

class PillScanScreen extends StatefulWidget {
  const PillScanScreen({super.key});

  @override
  State<PillScanScreen> createState() => _PillScanScreenState();
}

class _PillScanScreenState extends State<PillScanScreen> {
  // 현재 선택된 알약 모양 (기본값: 동그라미)
  PillShape _selectedShape = PillShape.circle;

  // 스캔 결과를 저장할 변수
  String _scanResult = "스캔 버튼을 눌러 알약 사진을 촬영해 주세요.";

  // 알약 모양에 따라 아이콘을 반환하는 함수
  IconData _getIconForShape(PillShape shape) {
    switch (shape) {
      case PillShape.circle:
        return Icons.circle_outlined;
      case PillShape.halfMoon:
        // 반달 모양에 가장 가까운 아이콘 (임시)
        return Icons.water_drop_outlined;
      case PillShape.triangle:
        return Icons.change_history_outlined; // 세모 아이콘
      case PillShape.longCircle:
        return Icons.lens_outlined; // 길쭉한 원통 아이콘 (임시)
      default:
        return Icons.help_outline;
    }
  }

  // 모양 선택 버튼 위젯
  Widget _buildShapeButton(PillShape shape) {
    final bool isSelected = _selectedShape == shape;

    // 알약 모양의 이름 (사용자에게 표시될 텍스트)
    String shapeName;
    switch (shape) {
      case PillShape.circle:
        shapeName = '동그라미';
        break;
      case PillShape.halfMoon:
        shapeName = '반달모양';
        break;
      case PillShape.triangle:
        shapeName = '세모';
        break;
      case PillShape.longCircle:
        shapeName = '긴동그라미';
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShape = shape;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForShape(shape),
              color: isSelected ? primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              shapeName,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 스캔(카메라 실행) 로직 (임시 구현)
  void _startScan() async {
    // 실제 카메라 실행 로직이 여기에 들어갑니다. (image_picker 또는 camera 패키지 사용)

    setState(() {
      _scanResult = "알약 모양: ${_getShapeName(_selectedShape)}으로 스캔 중...";
    });

    // 5초 후 임시 결과 표시
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _scanResult =
          """
      [스캔 결과]
      - 모양: ${_getShapeName(_selectedShape)}
      - 식별된 약품: **타이레놀 500mg**
      - 성분: 아세트아미노펜
      - 효능: 해열, 진통
      - 주의사항: 하루 최대 4000mg 초과 금지.
      """;
    });
  }

  String _getShapeName(PillShape shape) {
    switch (shape) {
      case PillShape.circle:
        return '동그라미';
      case PillShape.halfMoon:
        return '반달모양';
      case PillShape.triangle:
        return '세모';
      case PillShape.longCircle:
        return '긴동그라미';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 알약 스캔'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. 알약 모양 선택 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '알약 모양 선택',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: PillShape.values.map(_buildShapeButton).toList(),
                ),
              ],
            ),
          ),

          const Divider(),

          // 2. 스캔 버튼 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text(
                '알약 스캔',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50), // 버튼 너비를 최대로
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 3. 카메라 미리보기/틀 오버레이 영역 (시뮬레이션)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12, // 카메라 미리보기 영역 시뮬레이션
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    '여기는 카메라 미리보기 영역입니다.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  // 선택된 모양의 틀 (Overlay) 시뮬레이션
                  Icon(
                    _getIconForShape(_selectedShape),
                    color: primaryColor.withOpacity(0.7),
                    size: 150,
                  ),
                  const Positioned(
                    bottom: 20,
                    child: Text(
                      '선택된 모양 안에 알약을 맞춰주세요.',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          // 4. 스캔 결과 정보 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔍 스캔 결과',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: primaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _scanResult,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
