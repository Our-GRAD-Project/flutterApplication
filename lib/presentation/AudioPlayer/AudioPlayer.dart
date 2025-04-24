import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerSheet extends StatefulWidget {
  const AudioPlayerSheet({super.key});

  @override
  State<AudioPlayerSheet> createState() => _AudioPlayerSheetState();
}

class _AudioPlayerSheetState extends State<AudioPlayerSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayer.setAsset('assets/audio/sample.mp3');
    _duration = _audioPlayer.duration ?? Duration.zero;
    _audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void _togglePlay() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = _audioPlayer.playing;
    });
  }

  void _seekBy(Duration offset) {
    final newPos = _position + offset;
    _audioPlayer.seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void _showSpeedDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final rate = 0.75 + (index * 0.25);
            return ListTile(
              title: Text('${rate.toStringAsFixed(2)}x'),
              onTap: () {
                _audioPlayer.setSpeed(rate);
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    );
  }

  void _showVolumeDialog() {
    double currentVolume = _audioPlayer.volume;
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Volume",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Slider(
                      value: currentVolume,
                      min: 0,
                      max: 1,
                      onChanged: (val) {
                        setStateDialog(() => currentVolume = val);
                        _audioPlayer.setVolume(val);
                      },
                      activeColor: Colors.blue,
                      inactiveColor: Colors.blue.shade100,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xffF8F6F6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 32.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              'assets/images/temp_book.png',
              width: 200.w,
              height: 260.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.h),
          Slider(
            value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.grey.shade400,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position), style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
              Text(_formatDuration(_duration), style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _showSpeedDialog,
                icon: Icon(Icons.tune, size: 28.sp, color: Colors.black87),
              ),
              IconButton(
                onPressed: () => _seekBy(const Duration(seconds: -10)),
                icon: Icon(Icons.skip_previous_rounded, size: 36.sp),
              ),
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 64.sp,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () => _seekBy(const Duration(seconds: 10)),
                icon: Icon(Icons.skip_next_rounded, size: 36.sp),
              ),
              IconButton(
                onPressed: _showVolumeDialog,
                icon: Icon(Icons.volume_up_rounded, size: 28.sp, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
