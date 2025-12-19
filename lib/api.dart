import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseURL = "https://myproject-production-22db.up.railway.app";

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

// 회원가입
Future<Map<String, dynamic>> registerApi(String name, String birth_date, String email, String password) async {
  final res = await http.post(
    Uri.parse('$baseURL/api/users/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "name": name,
      "birth_date": birth_date,
      "email": email,
      "password": password
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('회원가입 실패');
  }

  final body = jsonDecode(res.body);
  final data = body['data'];
  
  return data;
}

// 로그인
Future<Map<String, dynamic>> loginApi(String email, String password) async {
  final res = await http.post(
    Uri.parse('$baseURL/api/users/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('로그인 실패');
  }

  final body = jsonDecode(res.body);
  final data = body['data'];
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', data['token']);

  return data;
}

// 정보조회
Future<Map<String, dynamic>> meApi() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.get(
    Uri.parse('$baseURL/api/users/me'),
    headers: {
      'Content-Type': 'application/json', 
      'Authorization': 'Bearer $token'
    },
  );

  if (res.statusCode != 200) {
    throw Exception('정보조회 실패');
  }

  final body = jsonDecode(res.body);
  final data = body['data'];

  return data;
}

// 복약 목록 조회
Future<List<dynamic>> medicationsApi() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.get(
    Uri.parse('$baseURL/api/medications'),
    headers: {
      'Content-Type': 'application/json', 
      'Authorization': 'Bearer $token'
    },
  );

  if (res.statusCode != 200) {
    throw Exception('복약 목록 조회 실패');
  }

  final body = jsonDecode(res.body);
  final data = body['data'];

  return data;
}

// 복약 추가
Future<Map<String, dynamic>> addMedicationApi(Map<String, dynamic> body) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.post(
    Uri.parse('$baseURL/api/medications'),
    headers: {
      'Content-Type': 'application/json', 
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(body),
  );

  if (res.statusCode != 200) {
    throw Exception('복약 추가 실패');
  }

  final response = jsonDecode(res.body);
  final data = response['data'];

  return data;
}

//복약 수정
Future<Map<String, dynamic>> updateMedicationApi(int id, Map<String, dynamic> body,) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.put(
    Uri.parse('$baseURL/api/medications/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  if (res.statusCode != 200) {
    throw Exception('복약 수정 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

//복약 삭제
Future<Map<String, dynamic>> deleteMedicationApi(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.delete(
    Uri.parse('$baseURL/api/medications/$id'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) {
    throw Exception('복약 삭제 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

//스케줄 등록
Future<Map<String, dynamic>> addScheduleApi({
  required int userMedicationId,
  required List<String> timeOfDay,
  required List<String> daysOfWeek,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.post(
    Uri.parse('$baseURL/api/schedules'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'user_medication_id': userMedicationId,
      'time_of_day': timeOfDay,
      'days_of_week': daysOfWeek,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('스케줄 등록 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

//스케줄 조회
Future<List<dynamic>> getSchedulesApi() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.get(
    Uri.parse('$baseURL/api/medications/schedule'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) {
    throw Exception('스케줄 조회 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

//복약 기록 등록
Future<Map<String, dynamic>> addMedicationLogApi(int medicationId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.post(
    Uri.parse('$baseURL/api/logs'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'id': medicationId,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('복약 기록 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

//복약 기록 조회
Future<List<dynamic>> getMedicationLogsApi(int medicationId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.get(
    Uri.parse('$baseURL/api/medications/logs?id=$medicationId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) {
    throw Exception('복약 기록 조회 실패');
  }

  final response = jsonDecode(res.body);
  return response['data'];
}

// 복약 기록 확인 
Future<List<bool>> getMonthlySummaryApi({
  required int year,
  required int month,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final res = await http.get(
    Uri.parse('$baseURL/api/logs/summary?year=$year&month=$month'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) {
    throw Exception('월별 복약 요약 실패');
  }

  final response = jsonDecode(res.body);
  return List<bool>.from(response['data']);
}