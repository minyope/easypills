import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // API 기본 주소 (본인의 서버 주소로 변경하세요)
  static const String baseUrl = "https://example.com/api";

  // POST 호출 함수
  static Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // 필요하다면 여기에 토큰 추가: 'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: jsonEncode(data), // 데이터를 JSON 문자열로 변환
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시 응답 본문을 JSON으로 파싱하여 반환
        return jsonDecode(response.body);
      } else {
        // 실패 시 에러 던지기
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
