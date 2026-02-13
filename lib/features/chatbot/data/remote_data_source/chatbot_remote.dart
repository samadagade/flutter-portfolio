import 'dart:convert';
import 'package:http/http.dart' as http;

class PortfolioBotApi {
  final String baseUrl; // e.g. http://10.0.2.2:8080 for Android emulator
  final String? basicAuth; // e.g. "Basic xxx" (optional)

  PortfolioBotApi({
    required this.baseUrl,
    this.basicAuth,
  });

  Future<ChatResponse> ask({
    required String sessionId,
    required String prompt,
  }) async {
    final uri = Uri.parse('$baseUrl/ai/portfolio');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (basicAuth != null && basicAuth!.trim().isNotEmpty) {
      headers['Authorization'] = basicAuth!;
    }

    final body = jsonEncode({
      'sessionId': sessionId,
      'prompt': prompt,
    });

    final res = await http.post(uri, headers: headers, body: body);
   
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return ChatResponse.fromJson(data);
    }

    // show backend error in exception
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }
}

class ChatResponse {
  final String answer;
  final bool fallback; // if backend sends it (optional)

  ChatResponse({required this.answer, required this.fallback});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: (json['response'] ?? '').toString(),
      fallback: (json['fallback'] ?? false) == true,
    );
  }
}

