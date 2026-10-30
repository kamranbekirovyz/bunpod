import 'package:bunpod/bunpod.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_ui/material_ui.dart';

abstract final class ContactSupport {
  static Future<void> open(BuildContext context) async {
    try {
      await FlutterEmailSender.send(
        Email(
          recipients: [
            AppValues.supportEmail,
          ],
          subject: 'Something feels off in BunPod',
        ),
      );
    } on FlutterEmailSenderNotAvailableException {
      if (!context.mounted) return;

      showExpressiveSnack(
        context: context,
        message: 'No mail app. Write to ${AppValues.supportEmail}',
        icon: Icons.mail_outline_rounded,
      );
    }
  }
}
