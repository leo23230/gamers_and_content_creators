import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';

class SoundcloudCard extends StatefulWidget {
  @override
  _SoundcloudCardState createState() => _SoundcloudCardState();
}

class _SoundcloudCardState extends State<SoundcloudCard> {
  final double cardHeight = 480;
  final double cardWidth = 360;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();


  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return Container( //TWITCH
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(cardRoundness),
        color: Colors.deepOrange[800],
      ),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints.tight(Size(80,80)),
            child: Column(
              children: [
                Image.asset('assets/SoundcloudLogo.png',scale: 1),
              ],
            ),
          ),
          audioSlider(),
          InkWell(
            onTap: () async{
              await getAudio();
              print("done");
            },
            child: Icon(
              _playing == false
                  ? Icons.play_circle_outline
                  : Icons.pause_circle_outline,
              size: 40,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget audioSlider(){
    return Slider.adaptive(
      min: 0.0,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState((){
          audioPlayer.seek(new Duration (seconds: value.toInt()));
        });
      }
    );
  }
  Future getAudio() async{
    var url = "https://soundcloud.com/melenium/lean-on-vs-itapii";

    //
    if(_playing){
      //pause song
      var res = await audioPlayer.pause();
      if(res == 1) {
        setState(() {
          _playing = false;
          audioPlayer.setVolume(0.2);
        });
      }
    }
    else {
      //play song
      var res = await audioPlayer.play(url, isLocal: false);
      if(res == 1){
        setState(() {
          _playing = true;
        });
      }
    }

    audioPlayer.onDurationChanged.listen((Duration dd){
      setState(() {
        duration = dd;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      position = dd;
    });
  }
}