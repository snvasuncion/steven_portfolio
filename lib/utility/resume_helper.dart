import 'package:web/web.dart' as web;

class ResumeHelper {
  static const String resumePath = 'assets/pdfs/Steven_Nikko_Asuncion_CV.pdf';

  /// Triggers a download of the resume PDF in the browser.
  static void download() {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = resumePath
      ..target = '_blank'
      ..download = 'Steven_Nikko_Asuncion_CV.pdf';
    anchor.click();
    anchor.remove();
  }
}
