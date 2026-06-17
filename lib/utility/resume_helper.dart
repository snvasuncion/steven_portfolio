import 'package:flutter/services.dart' show rootBundle;
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class ResumeHelper {
  static const String resumePath = 'assets/pdfs/Steven_Nikko_Asuncion_CV.pdf';

  /// Loads the resume PDF via Flutter's asset bundle and triggers a browser download.
  static Future<void> download() async {
    try {
      final data = await rootBundle.load(resumePath);
      final bytes = data.buffer.asUint8List();
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: 'application/pdf'),
      );
      final url = web.URL.createObjectURL(blob);

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement
        ..href = url
        ..target = '_blank'
        ..download = 'Steven_Nikko_Asuncion_CV.pdf'
        ..style.display = 'none';

      web.document.body!.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
    } catch (e) {
      // Fallback: try direct URL as backup
      final fallback = web.document.createElement('a') as web.HTMLAnchorElement
        ..href = resumePath
        ..target = '_blank'
        ..download = 'Steven_Nikko_Asuncion_CV.pdf';
      fallback.click();
      fallback.remove();
    }
  }
}
