import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {
  static final DataProvider _instance = DataProvider._internal();
  factory DataProvider() => _instance;
  DataProvider._internal();

  Map<String, dynamic>? _cachedData;
  bool _isFetching = false;
  final List<void Function(Map<String, dynamic>)> _listeners = [];
  
  // ADD THESE TWO LINES for Projects:
  List<dynamic>? _cachedProjects;
  bool _isFetchingProjects = false;

  // Add public getter for profile data
  Map<String, dynamic>? get cachedData => _cachedData;

  // Add public getter for projects data
  List<dynamic>? get cachedProjects => _cachedProjects;

  Future<Map<String, dynamic>> getProfileData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    if (_isFetching) {
      return Future.delayed(const Duration(milliseconds: 100)).then((_) => getProfileData());
    }

    _isFetching = true;
    try {
      final response = await http.get(Uri.parse('https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/profile/1'));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch profile data');
      }
      
      _cachedData = jsonDecode(response.body);
      _notifyListeners();
      return _cachedData!;
    } catch (e) {
      return _getDefaultData();
    } finally {
      _isFetching = false;
    }
  }

  // ADD THIS METHOD for Projects:
  Future<List<dynamic>> getProjectsData() async {
    if (_cachedProjects != null) {
      return _cachedProjects!;
    }

    if (_isFetchingProjects) {
      return Future.delayed(const Duration(milliseconds: 100)).then((_) => getProjectsData());
    }

    _isFetchingProjects = true;
    try {
      final response = await http.get(Uri.parse('https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/projects'));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch projects data');
      }
      
      _cachedProjects = jsonDecode(response.body);
      return _cachedProjects!;
    } catch (e) {
      return []; // Return empty array on error
    } finally {
      _isFetchingProjects = false;
    }
  }

  Map<String, dynamic> _getDefaultData() {
    // Your existing default data here
    return {
      'name': 'Steven Nikko V. Asuncion',
      'title': 'Software Developer',
      // ... rest of your default data
    };
  }

  void addListener(void Function(Map<String, dynamic>) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(Map<String, dynamic>) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    if (_cachedData != null) {
      for (final listener in _listeners) {
        listener(_cachedData!);
      }
    }
  }

  void preloadData() {
    getProfileData();
  }
}