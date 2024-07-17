import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "";
const appCertificate = '';
const token = "";
const channel = "";

class CallingPage extends StatefulWidget {
  final int callType; // 0 for audio, 1 for video

  const CallingPage({super.key, required this.callType});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _videoEnabled = true;
  bool _audioMuted = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();

    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    if (widget.callType == 1) {
      _videoEnabled = true;
      await _engine.enableVideo();
      await _engine.startPreview();
      debugPrint("Video enabled");
    } else {
      _videoEnabled = false;
      await _engine.disableVideo();
      debugPrint("Video disabled");
    }

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _endCall() async {
    await _engine.leaveChannel();
    Navigator.pop(context);
  }

  Future<void> _toggleVideo() async {
    setState(() {
      _videoEnabled = !_videoEnabled;
    });
    if (_videoEnabled) {
      await _engine.enableVideo();
      await _engine.startPreview();
      debugPrint("Video enabled");
    } else {
      await _engine.disableVideo();
      await _engine.stopPreview();
      debugPrint("Video disabled");
    }
  }

  Future<void> _toggleMute() async {
    setState(() {
      _audioMuted = !_audioMuted;
    });
    await _engine.muteLocalAudioStream(_audioMuted);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if (widget.callType == 1 && _videoEnabled)
              Center(
                child: _remoteVideo(),
              ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined && _videoEnabled
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300]),
                          child: const Center(
                              child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )),
                        ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: _endCall,
                      child: const Icon(Icons.call_end),
                    ),
                    const SizedBox(width: 16),
                    if (widget.callType == 1)
                      FloatingActionButton(
                        backgroundColor:
                            _videoEnabled ? Colors.blue : Colors.grey,
                        onPressed: _toggleVideo,
                        child: Icon(_videoEnabled
                            ? Icons.videocam
                            : Icons.videocam_off),
                      ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      backgroundColor: _audioMuted ? Colors.grey : Colors.blue,
                      onPressed: _toggleMute,
                      child: Icon(_audioMuted ? Icons.mic_off : Icons.mic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
