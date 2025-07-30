import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/utilities/audio_input.dart';
import '../src/utilities/audio_output.dart';
import '../src/utilities/video_input.dart';

final audioInputProvider = ChangeNotifierProvider<AudioInput>((ref) {
  return AudioInput();
});

final videoInputProvider = Provider<VideoInput>((ref) {
  return VideoInput();
});

final audioOutputProvider = Provider<AudioOutput>((ref) {
  return AudioOutput();
});
