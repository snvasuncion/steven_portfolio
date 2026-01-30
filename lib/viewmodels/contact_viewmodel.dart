import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactViewModel {
  final String email = "asuncionsteven@gmail.com";
  final String linkedinUrl =
      "https://www.linkedin.com/in/steven-nikko-villanueva-asuncion/";
  final String githubUrl = "https://github.com/snvasuncion";

  final String profileId = "1";
  final String apiUrl =
      "https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/profile";

  String getEmail() => email;
  String getLinkedinUrl() => linkedinUrl;
  String getGithubUrl() => githubUrl;

  Future<void> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$profileId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch profile data: ${response.statusCode}');
      }

      Map<String, dynamic> profileData = jsonDecode(response.body);

      List<dynamic> messages = [];
      if (profileData['messages'] != null &&
          profileData['messages'].isNotEmpty) {
        messages = jsonDecode(profileData['messages']);
      }

      Map<String, String> newMessage = {
        'name': name,
        'email': email,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      messages.add(newMessage);

      final updateResponse = await http.put(
        Uri.parse('$apiUrl/$profileId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ...profileData,
          'messages': jsonEncode(messages),
        }),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception('Failed to send message: ${updateResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$profileId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }

      Map<String, dynamic> profileData = jsonDecode(response.body);

      if (profileData['messages'] == null || profileData['messages'].isEmpty) {
        return [];
      }

      return List<Map<String, dynamic>>.from(
          jsonDecode(profileData['messages']));
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }
}
