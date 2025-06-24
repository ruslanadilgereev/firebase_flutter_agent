import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AdaptiveChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final Color iOSBackgroundColor;
  final Color iOSTextColor;
  final Color androidBackgroundColor;
  final Color androidTextColor;

  const AdaptiveChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.iOSBackgroundColor = Colors.blue,
    this.iOSTextColor = Colors.white,
    this.androidBackgroundColor = Colors.green,
    this.androidTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isIOS) {
      return _buildIOSBubble(context);
    } else if (Platform.isAndroid) {
      return _buildAndroidBubble(context);
    } else {
      return _buildIOSBubble(context);
    }
  }

  Widget _buildIOSBubble(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomPaint(
          painter: ChatBubblePainter(color: iOSBackgroundColor, isUser: isUser),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18), // More rounded for iOS
            ),
            child: Text(message, style: TextStyle(color: iOSTextColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildAndroidBubble(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: androidBackgroundColor,
            borderRadius: BorderRadius.circular(8), // Less rounded for Android
          ),
          child: Text(message, style: TextStyle(color: androidTextColor)),
        ),
      ),
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final bool isUser;

  ChatBubblePainter({required this.color, required this.isUser});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (isUser) {
      path.moveTo(size.width - 15, size.height);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width,
        size.height - 10,
      );
      path.lineTo(size.width, 10);
      path.quadraticBezierTo(size.width, 0, size.width - 10, 0);
      path.lineTo(10, 0);
      path.quadraticBezierTo(0, 0, 0, 10);
      path.lineTo(0, size.height - 10);
      path.quadraticBezierTo(0, size.height, 10, size.height);
      path.lineTo(size.width - 15, size.height);
    } else {
      path.moveTo(15, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - 10);
      path.lineTo(0, 10);
      path.quadraticBezierTo(0, 0, 10, 0);
      path.lineTo(size.width - 10, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 10);
      path.lineTo(size.width, size.height - 10);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 10,
        size.height,
      );
      path.lineTo(15, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
