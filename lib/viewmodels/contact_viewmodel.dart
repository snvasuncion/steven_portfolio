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

  /// Parses a messages field from MockAPI, which may be:
  /// - A JSON-encoded string (normal): `"[{...}]"`
  /// - A raw List (after MockAPI reset): `["messages 1"]`
  /// Returns only valid message Map entries, discarding any placeholders.
  List<Map<String, dynamic>> _parseMessages(dynamic rawMessages) {
    if (rawMessages == null) return [];

    List<dynamic> parsed = [];

    if (rawMessages is String) {
      if (rawMessages.isEmpty) return [];
      try {
        parsed = jsonDecode(rawMessages) as List<dynamic>;
      } catch (_) {
        return [];
      }
    } else if (rawMessages is List) {
      parsed = rawMessages;
    } else {
      return [];
    }

    // Filter out non-Map entries (e.g. MockAPI placeholder strings like "messages 1")
    return parsed
        .whereType<Map<String, dynamic>>()
        .where((m) => m.containsKey('name') && m.containsKey('message'))
        .toList();
  }

  Future<Map<String, dynamic>> _fetchProfile() async {
    final response = await http.get(Uri.parse('$apiUrl/$profileId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _putProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$profileId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  // ---------------------------------------------------------------------------
  // Public message board (approved messages)
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getMessages() async {
    try {
      final profileData = await _fetchProfile();
      return _parseMessages(profileData['messages']);
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Pending queue — new submissions land here, awaiting moderation
  // ---------------------------------------------------------------------------

  /// Submits a new message into the **pending** queue instead of publishing
  /// it directly, so it can be reviewed via the admin panel first.
  Future<void> sendMessage({
    required String name,
    required String message,
  }) async {
    try {
      final profileData = await _fetchProfile();
      final pending = _parseMessages(profileData['pendingMessages']);

      pending.add({
        'name': name,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await _putProfile({
        ...profileData,
        'pendingMessages': jsonEncode(pending),
      });
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingMessages() async {
    try {
      final profileData = await _fetchProfile();
      return _parseMessages(profileData['pendingMessages']);
    } catch (e) {
      throw Exception('Error fetching pending messages: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Moderation actions
  // ---------------------------------------------------------------------------

  /// Moves [toApprove] from the pending queue to the public message board.
  Future<void> approveMessages(List<Map<String, dynamic>> toApprove) async {
    try {
      final profileData = await _fetchProfile();
      final approved = _parseMessages(profileData['messages']);
      final pending = _parseMessages(profileData['pendingMessages']);

      final approveIds = toApprove.map((m) => m['id'] as String).toSet();
      approved.addAll(toApprove);
      pending.removeWhere((m) => approveIds.contains(m['id'] as String));

      await _putProfile({
        ...profileData,
        'messages': jsonEncode(approved),
        'pendingMessages': jsonEncode(pending),
      });
    } catch (e) {
      throw Exception('Error approving messages: $e');
    }
  }

  /// Permanently removes the messages with the given [ids] from the pending queue.
  Future<void> rejectMessages(List<String> ids) async {
    try {
      final profileData = await _fetchProfile();
      final pending = _parseMessages(profileData['pendingMessages']);
      final rejectSet = ids.toSet();
      pending.removeWhere((m) => rejectSet.contains(m['id'] as String));

      await _putProfile({
        ...profileData,
        'pendingMessages': jsonEncode(pending),
      });
    } catch (e) {
      throw Exception('Error rejecting messages: $e');
    }
  }
}
