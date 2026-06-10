import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final _appLinks = AppLinks();

  Stream<Uri> get authLinks => _appLinks.uriLinkStream;

  Future<void> loginWithGitHub() async {
    final uri = Uri.parse('http://192.168.178.126/auth/github/login');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
