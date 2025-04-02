import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../greenthumb/service.dart';
import '../platform_util.dart';
import '../styles.dart';
import '../widgets/gt_button.dart';
import 'view_model.dart';

class InterruptImagePicker extends StatefulWidget {
  InterruptImagePicker({
    required this.message,
    required this.onResume,
    super.key,
  }) : assert(message.toolResponse == null || onResume == null),
       selectedImage =
           message.toolResponse?.output != null
               ? base64Decode(message.toolResponse!.output.split(',').last)
               : null;

  final InterruptMessage message;
  final Uint8List? selectedImage;
  final ToolResumeCallback? onResume;

  @override
  State<InterruptImagePicker> createState() => _InterruptImagePickerState();
}

class _InterruptImagePickerState extends State<InterruptImagePicker> {
  Uint8List? _currentImageBytes;
  var _isCompressing = false;

  @override
  void initState() {
    super.initState();
    _currentImageBytes = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // Keep the Take picture button centered vertically
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.extraLargePadding,
          ),
          child: GtButton(
            style:
                _currentImageBytes == null
                    ? GtButtonStyle.elevated
                    : GtButtonStyle.outlined,
            onPressed:
                _isCompressing || widget.onResume == null
                    ? null
                    : () => _getPicture(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Text('Take picture')],
            ),
          ),
        ),
      ),
      // Position text block centered between app bar and button
      Align(
        alignment: const Alignment(0, -0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.extraLargePadding,
          ),
          child: Text(
            widget.message.text,
            style: AppTextStyles.subheading,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // Position image and submit button at bottom
      if (_currentImageBytes != null)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(AppLayout.extraLargePadding),
            child: Column(
              children: [
                Image.memory(
                  _currentImageBytes!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: AppLayout.defaultPadding),
                GtButton(
                  style: GtButtonStyle.elevated,
                  onPressed: widget.onResume == null ? null : _submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
    ],
  );

  void _getPicture(BuildContext context) async {
    final file = await PlatformUtil.getPicture(context);
    if (file == null) return;
    _currentImageBytes = await file.readAsBytes();
    setState(() {});
  }

  void _submit() async {
    assert(widget.onResume != null);
    assert(_currentImageBytes != null);

    // shrink the image if it's too large for Genkit
    setState(() => _isCompressing = true);

    // give the web a chance to show the disabled buttons
    Future.delayed(const Duration(microseconds: kIsWeb ? 250 : 0), () async {
      final bytes = (await _resizeImageIfNeeded(_currentImageBytes!))!;

      widget.onResume!(
        ref: widget.message.toolRequest!.ref,
        name: widget.message.toolRequest!.name,
        output: 'data:image/jpeg;base64,${base64Encode(bytes)}',
      );
      setState(() => _isCompressing = false);
    });
  }

  Future<Uint8List?> _resizeImageIfNeeded(Uint8List bytes) async {
    debugPrint('Starting image resize operation with ${bytes.length} bytes');

    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      debugPrint('Failed to decode image, returning null');
      return null;
    }

    debugPrint(
      'Original image dimensions: ${originalImage.width}x${originalImage.height}',
    );

    // Early bailout if image is already small enough
    if (originalImage.width <= 400 && originalImage.height <= 400) {
      debugPrint('Image already small enough, skipping resize');
      return bytes;
    }

    // resize image to max dimension of 400px while maintaining aspect ratio
    final resized = img.copyResize(
      originalImage,
      width: originalImage.width > originalImage.height ? 400 : null,
      height: originalImage.height >= originalImage.width ? 400 : null,
    );

    debugPrint('Resized image dimensions: ${resized.width}x${resized.height}');

    // encode as JPG with 85% quality and create data URL
    final jpgBytes = img.encodeJpg(resized, quality: 85);
    debugPrint('Compressed image size: ${jpgBytes.length} bytes');

    return jpgBytes;
  }
}
