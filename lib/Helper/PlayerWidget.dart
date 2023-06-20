import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as JustAudio;
import 'package:neuro/Helper/size_config.dart';

import 'FirebaseManager.dart';
import 'Helper.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;

  const PlayerWidget({
    Key? key,
    required this.url,
    this.mode = PlayerMode.MEDIA_PLAYER,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayerWidgetState(url, mode);
  }
}

class PlayerWidgetState extends State<PlayerWidget>
    with SingleTickerProviderStateMixin {
  String url;
  PlayerMode mode;

  late AudioPlayer _audioPlayer;
  PlayerState? _audioPlayerState;
  Duration? _duration;
  Duration? _position;
  bool animation = false;

  PlayerState _playerState = PlayerState.STOPPED;
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;

  bool get _isPaused => _playerState == PlayerState.PAUSED;

  String get _durationText => _printDuration(_duration!);

  //String get _durationText => _duration?.toString().split('.').first ?? '';

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String get _positionText => _printDuration(_position!);

  bool get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRoute.SPEAKERS;

  PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(10),
          left: getProportionateScreenWidth(107),
          right: getProportionateScreenWidth(18)),
      decoration: BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Helper.hexToColor("#5BAEE2"),
            Helper.hexToColor("#C078BA"),
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(getProportionateScreenWidth(16)),
            topLeft: Radius.circular(getProportionateScreenWidth(16)),
            bottomLeft: Radius.circular(getProportionateScreenWidth(16))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: const Key('play_button'),
                onPressed: _isPlaying ? _pause : _play,
                iconSize: getProportionateScreenWidth(35),
                icon: _isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                color: Colors.white,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Slider(
                          onChanged: (v) {
                            final duration = _duration;
                            if (duration == null) {
                              return;
                            }
                            final Position = v * duration.inMilliseconds;
                            _audioPlayer
                                .seek(Duration(milliseconds: Position.round()));
                          },
                          activeColor: Helper.hexToColor("#ffffff"),
                          inactiveColor: Helper.hexToColor("#ffffff"),
                          value: (_position != null &&
                                  _duration != null &&
                                  _position!.inMilliseconds > 0 &&
                                  _position!.inMilliseconds <
                                      _duration!.inMilliseconds)
                              ? _position!.inMilliseconds /
                                  _duration!.inMilliseconds
                              : 0.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          /*_position != null || _duration != null
              ?*/
          Container(
            margin: EdgeInsets.only(right: getProportionateScreenWidth(15)),
            alignment: Alignment.centerRight,
            child: AnimatedDefaultTextStyle(
              child: Text(_position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : ''),
              style: animation
                  ? TextStyle(
                      fontSize: getProportionalFontSize(14),
                      color: Colors.white,
                      fontFamily: "poppins")
                  : TextStyle(
                      fontSize: getProportionalFontSize(6),
                      color: Colors.white,
                      fontFamily: "poppins"),
              duration: Duration(milliseconds: 200),
            ),
            /*Text(
                  _position != null
                      ? '$_positionText / $_durationText'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: TextStyle(
                      fontSize: getProportionalFontSize(14),
                      color: Colors.white,
                      fontFamily: "poppins"),
                ),*/
          ),
          // : Container(),
          Container(
            height: 5,
          ),
        ],
      ),
    );
    SizeConfig().init(context);
  }

  void _initAudioPlayer() async {
    _audioPlayer = AudioPlayer(mode: mode);
    final player = JustAudio.AudioPlayer();
    _duration = await player.setUrl(url);
    animation = true;
    if (this.mounted) { // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // optional: listen for notification updates in the background
        _audioPlayer.notificationService.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.notificationService.setNotification(
          title: 'Neuro',
          artist: '',
          albumTitle: '',
          imageUrl: '',
          forwardSkipInterval: const Duration(seconds: 30),
          // default is 30s
          backwardSkipInterval: const Duration(seconds: 30),
          // default is 30s
          duration: duration,
          enableNextTrackButton: true,
          enablePreviousTrackButton: true,
        );
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('command: $command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _audioPlayerState = state);
      }
    });

    _playingRouteState = PlayingRoute.SPEAKERS;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    if (FirebaseManager().playerWidgetRight != null) {
      FirebaseManager().playerWidgetRight!._pause();
      FirebaseManager().playerWidgetRight = null;
    }
    if (FirebaseManager().playerWidgetLeft != null) {
      FirebaseManager().playerWidgetLeft!._pause();
      FirebaseManager().playerWidgetLeft = null;
    }
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }
    FirebaseManager().playerWidgetRight = this;

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate();

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => _playingRouteState = _playingRouteState.toggle());
    }
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }
}

class PlayerWidgetLeft extends StatefulWidget {
  final String url;
  final PlayerMode mode;
  final int timeStamp;

  const PlayerWidgetLeft({
    Key? key,
    required this.url,
    required this.timeStamp,
    this.mode = PlayerMode.MEDIA_PLAYER,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayerWidgetStateLeft(url, mode, timeStamp);
  }
}

class PlayerWidgetStateLeft extends State<PlayerWidgetLeft>
    with SingleTickerProviderStateMixin {
  String url;
  PlayerMode mode;
  int timeStamp;

  late AudioPlayer _audioPlayer;
  PlayerState? _audioPlayerState;
  Duration? _duration;
  Duration? _position;
  bool animation = false;

  PlayerState _playerState = PlayerState.STOPPED;
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;

  bool get _isPaused => _playerState == PlayerState.PAUSED;

  String get _durationText => _printDuration(_duration!);

  String get _positionText => _printDuration(_position!);

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  bool get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRoute.SPEAKERS;

  PlayerWidgetStateLeft(this.url, this.mode, this.timeStamp);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: getProportionateScreenWidth(250),
      margin: EdgeInsets.only(
        bottom: getProportionateScreenHeight(10),
        left: getProportionateScreenWidth(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(getProportionateScreenWidth(16)),
            bottomRight: Radius.circular(getProportionateScreenWidth(16)),
            bottomLeft: Radius.circular(getProportionateScreenWidth(16))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                key: const Key('play_button'),
                onPressed: _isPlaying ? _pause : _play,
                iconSize: getProportionateScreenWidth(35),
                icon: _isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                color: Helper.hexToColor("#5BAEE2"),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Slider(
                          onChanged: (v) {
                            final duration = _duration;
                            if (duration == null) {
                              return;
                            }
                            final Position = v * duration.inMilliseconds;
                            _audioPlayer
                                .seek(Duration(milliseconds: Position.round()));
                          },
                          activeColor: Helper.hexToColor("#5BAEE2"),
                          inactiveColor: Helper.hexToColor("#5BAEE2"),
                          value: (_position != null &&
                                  _duration != null &&
                                  _position!.inMilliseconds > 0 &&
                                  _position!.inMilliseconds <
                                      _duration!.inMilliseconds)
                              ? _position!.inMilliseconds /
                                  _duration!.inMilliseconds
                              : 0.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          /* _position != null || _duration != null
              ?*/
          Container(
            margin: EdgeInsets.only(right: getProportionateScreenWidth(15)),
            alignment: Alignment.centerRight,
            child: AnimatedDefaultTextStyle(
              child: Text(_position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : ''),
              style: animation
                  ? TextStyle(
                      fontSize: getProportionalFontSize(14),
                      color: Helper.hexToColor("#5BAEE2"),
                      fontFamily: "poppins")
                  : TextStyle(
                      fontSize: getProportionalFontSize(6),
                      color: Helper.hexToColor("#5BAEE2"),
                      fontFamily: "poppins"),
              duration: Duration(milliseconds: 200),
            ), /*Text(
                  _position != null
                      ? '$_positionText / $_durationText'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: TextStyle(
                      fontSize: getProportionalFontSize(14),
                      color: Helper.hexToColor("#5BAEE2"),
                      fontFamily: "poppins"),
                ),*/
          ),
          //: Container(),
          Container(
            height: 5,
          ),
        ],
      ),
    );
  }

  void _initAudioPlayer() async {
    _audioPlayer = AudioPlayer(mode: mode);

    final player = JustAudio.AudioPlayer();
    _duration = await player.setUrl(url);
    animation = true;
    setState(() {});
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // optional: listen for notification updates in the background
        //FirebaseManager().audioPlayer!.notificationService.startHeadlessService();

        // set at least title to see the notification bar on ios.
        /*FirebaseManager().audioPlayer!.notificationService.setNotification(
          title: 'Neuro',
          artist: '',
          albumTitle: '',
          imageUrl: '',
          forwardSkipInterval: const Duration(seconds: 30),
          // default is 30s
          backwardSkipInterval: const Duration(seconds: 30),
          // default is 30s
          duration: duration,
          enableNextTrackButton: true,
          enablePreviousTrackButton: true,
        );*/
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('command: $command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _audioPlayerState = state);
      }
    });

    _playingRouteState = PlayingRoute.SPEAKERS;
  }

  Future<int> _play() async {
    final playPosition;
    playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    /*if(FirebaseManager().audioPlayer != null){
      if(FirebaseManager().audioPlayer!.state != PlayerState.PLAYING){
        final result = await FirebaseManager().audioPlayer!.pause();
      }
    }*/
    if (FirebaseManager().playerWidgetLeft != null) {
      FirebaseManager().playerWidgetLeft!._pause();
      FirebaseManager().playerWidgetLeft = null;
    }
    if (FirebaseManager().playerWidgetRight != null) {
      FirebaseManager().playerWidgetRight!._pause();
      FirebaseManager().playerWidgetRight = null;
    }
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }
    FirebaseManager().playerWidgetLeft = this;
    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate();

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => _playingRouteState = _playingRouteState.toggle());
    }
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }
}
