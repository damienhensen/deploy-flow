import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final _appLinks = AppLinks();

  Stream<Uri> get authLinks => _appLinks.uriLinkStream;

  Future<void> loginWithGitHub() async {
    final uri = Uri.parse('http://192.168.178.126/auth/github/login');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final response = await http.post(
      Uri.parse('http://192.168.178.126/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to refresh token');
    }

    return jsonDecode(response.body);
  }
}
