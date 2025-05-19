import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'dart:async';
import 'dart:developer';
import 'package:record/record.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:typed_data';
import '../fake_mail_screen/mail_screen.dart';
import '../agentic_app_manager/app_agent.dart';

import '../app_state.dart';

class AudioAgenticAppManagerDemo extends StatelessWidget {
  const AudioAgenticAppManagerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: AgentManagedApp(),
    );
  }
}

class AgentManagedApp extends StatelessWidget {
  const AgentManagedApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppState manager = context.watch<AppState>();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: manager.appColor),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: context.watch<AppState>().fontFamily,
          fontSizeFactor: context.watch<AppState>().fontSizeFactor,
        ),
      ),
      home: const AudioAgentApp(title: 'myMail'),
    );
  }
}

class AudioAgentApp extends StatefulWidget {
  const AudioAgentApp({super.key, required this.title});

  final String title;

  @override
  State<AudioAgentApp> createState() => _AudioAgentAppState();
}

class _AudioAgentAppState extends State<AudioAgentApp> {
  final LiveGenerativeModel _liveModel = FirebaseVertexAI.instance
      .liveGenerativeModel(
        systemInstruction: Content.text('''
      You are a friendly and helpful app concierge. Your job is to help the user
      get the best, frictionless app experience. 
      If you have access to a tool that can configure the setting for
      the user and address their feedback, ALWAYS ask the user to confirm the
      change before making the change.
      '''),
        model: 'gemini-2.0-flash-live-preview-04-09',
        liveGenerationConfig: LiveGenerationConfig(
          speechConfig: SpeechConfig(voiceName: 'fenrir'),
          responseModalities: [ResponseModalities.audio],
        ),
      );
  late LiveSession _session; // Gemini Live Session
  bool _settingUpSession = false; // Session is getting set up
  bool _sessionOpened = false; // Session is open and ready to go.
  bool _conversationActive =
      false; // Session is set up and audio streams are active
  StreamController<bool> _stopController =
      StreamController<bool>(); // Stream controller to control audio output
  bool _audioReady = false;
  final _recorder = AudioRecorder();
  late Stream<Uint8List> inputStream;
  late AudioSource? audioSrc;
  late SoundHandle handle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAudio();
    });
  }

  ///
  /// AUDIO INPUT & OUTPUT
  ///
  Future<void> _initializeAudio() async {
    try {
      checkMicPermission();
      await SoLoud.instance.init(sampleRate: 24000, channels: Channels.mono);
      setState(() {
        _audioReady = true;
      });
    } catch (e) {
      log("Error during audio initialization: $e");
    }
  }

  void toggleConversation() async {
    _conversationActive ? await stopConversation() : await startConversation();
  }

  Future<void> startConversation() async {
    // Start the live session
    await _toggleLiveSession();

    // Start recording audio input stream
    inputStream = await startRecordingStream();
    log('Input stream should be recording!');

    // Wrap input stream audio bytes in InlineDataPart and send to Gemini
    Stream<InlineDataPart> inlineDataStream = inputStream.map((data) {
      print('recorded audio');
      return InlineDataPart('audio/pcm', data);
    });
    _session.sendMediaStream(inlineDataStream);

    // Start playing incoming audio output stream
    var audioSource = SoLoud.instance.setBufferStream(
      maxBufferSizeBytes:
          1024 * 1024 * 10, // 10MB of max buffer (not allocated)
      bufferingType: BufferingType.released,
      bufferingTimeNeeds: 0,
      onBuffering: (isBuffering, handle, time) {
        // When isBuffering==true, the stream is set to paused automatically till
        // it reaches bufferingTimeNeeds of audio data or until setDataIsEnded is called
        // or maxBufferSizeBytes is reached. When isBuffering==false, the playback stream
        // is resumed.
        log('Buffering: $isBuffering, Time: $time');
      },
    );
    var soundHandle = await SoLoud.instance.play(audioSource);

    setState(() {
      audioSrc = audioSource;
      handle = soundHandle;
    });

    log('Output stream should be playing!');

    setState(() {
      _conversationActive = true;
    });
  }

  Future<void> stopConversation() async {
    // Stop recording input audio
    stopRecording();

    // Stop playing output audio
    SoLoud.instance.setDataIsEnded(audioSrc!);
    await SoLoud.instance.stop(handle);

    // End the live session
    await _toggleLiveSession();

    setState(() {
      _conversationActive = false;
    });
  }

  Future<void> checkMicPermission() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception(
        'This app does not have microphone permissions. Please enable it.',
      );
    }
  }

  Future<Stream<Uint8List>> startRecordingStream() async {
    var recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 24000,
      numChannels: 1,
      echoCancel: true,
      noiseSuppress: true,
      androidConfig: AndroidRecordConfig(
        audioSource: AndroidAudioSource.voiceCommunication,
      ),
      iosConfig: IosRecordConfig(categoryOptions: []),
    );
    final devices = await _recorder.listInputDevices();
    //print(devices.toString());
    var stream = await _recorder.startStream(recordConfig);
    return stream;
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  // Audio Output

  ///
  /// VERTEX AI IN FIREBASE
  ///
  Future<void> _toggleLiveSession() async {
    setState(() {
      _settingUpSession = true;
    });

    if (!_sessionOpened) {
      _session = await _liveModel.connect();
      _sessionOpened = true;
      unawaited(processMessagesContinuously(stopSignal: _stopController));
    } else {
      await _session.close();
      _stopController.add(true);
      await _stopController.close();
      // Reset new StreamController
      _stopController = StreamController<bool>();
      _sessionOpened = false;
    }

    setState(() {
      _settingUpSession = false;
    });
  }

  Future<void> processMessagesContinuously({
    required StreamController<bool> stopSignal,
  }) async {
    bool shouldContinue = true;

    //listen to the stop signal stream
    stopSignal.stream.listen((stop) {
      if (stop) {
        shouldContinue = false;
      }
    });

    while (shouldContinue) {
      try {
        await for (final response in _session.receive()) {
          // Process the received message
          LiveServerMessage message = response.message;
          await _handleLiveServerMessage(message);
        }
      } catch (e) {
        log(e.toString());
        break;
      }

      // Optionally add a delay before restarting, if needed
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Small delay to prevent tight loops
    }
  }

  Future<void> _handleLiveServerMessage(LiveServerMessage response) async {
    if (response is LiveServerContent) {
      if (response.modelTurn != null) {
        await _handleLiveServerContent(response);
      }
      if (response.turnComplete != null && response.turnComplete!) {
        await _handleTurnComplete();
      }
      if (response.interrupted != null && response.interrupted!) {
        log('Interrupted: $response');
      }
    }

    if (response is LiveServerToolCall && response.functionCalls != null) {
      await _handleLiveServerToolCall(response);
    }
  }

  Future<void> _handleLiveServerContent(LiveServerContent response) async {
    log('received response!');
    final partList = response.modelTurn?.parts;
    if (partList != null) {
      for (final part in partList) {
        if (part is TextPart) {
          await _handleTextPart(part);
        } else if (part is InlineDataPart) {
          await _handleInlineDataPart(part);
        } else {
          log('receive part with type ${part.runtimeType}');
        }
      }
    }
  }

  Future<void> _handleLiveServerToolCall(LiveServerToolCall response) async {
    final functionCalls = response.functionCalls;
    if (functionCalls != null && functionCalls.isNotEmpty) {
      log("Gemini made a function call!");
    }
  }

  Future<void> _handleInlineDataPart(InlineDataPart part) async {
    // If DataPart is audio, add data to the output audio stream
    if (part.mimeType.startsWith('audio')) {
      print('audio part');
      var audioOutputSrc = audioSrc;
      if (audioOutputSrc != null) {
        SoLoud.instance.addAudioDataStream(audioOutputSrc, part.bytes);
      }
    }
  }

  Future<void> _handleTextPart(TextPart part) async {
    log('Text message from Gemini: ${part.text}');
  }

  Future<void> _handleTurnComplete() async {
    log('Model is done generating. Turn complete!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _audioReady ? toggleConversation : null,
            icon:
                _conversationActive
                    ? Icon(Icons.phone_disabled, color: Colors.red)
                    : Icon(Icons.phone, color: Colors.green),
          ),
        ],
      ),
      body: MyMailScreen(),
    );
  }
}
