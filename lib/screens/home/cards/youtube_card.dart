import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/models/channel_model.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/video_screen.dart';
import 'package:gamers_and_content_creators/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:gamers_and_content_creators/models/video_model.dart';

class YoutubeCard extends StatefulWidget {

  YoutubeCard({@required this.channelId});
  final String channelId;

  @override
  _YoutubeCardState createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {

  Channel _channel;
  bool _isLoading = false;
  String currentChannelId; //just to launch the channel
  final double cardHeight = 480;
  final double cardWidth = 360;

  @override
  void initState(){
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: widget.channelId);
    setState((){
      _channel = channel;
    });
  }

  _buildProfileInfo(){
    return GestureDetector(
      onTap: () {
        currentChannelId = widget.channelId;
        launch('https://www.youtube.com/channel/$currentChannelId');
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20,0,20,10),
        padding: EdgeInsets.all(20.0),
        height: 100.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 0.8),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35.0,
              backgroundImage: NetworkImage(_channel.profilePictureUrl),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    _channel.title,
                    style: GoogleFonts.lato(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_channel.subscriberCount} subscribers',
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 0.8),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 140.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: GoogleFonts.lato(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(70, 0, 0, 1),
      ),
      child: Column( // YOUTUBE CARD
        children: [
          Container(
            child: Image.asset('assets/YoutubeLogo.png',scale: 8),
          ),
          Container(
            height:400,
            child: _channel != null
                ?ListView.builder(
                itemCount: 1 + _channel.videos.length,
                itemBuilder: (BuildContext context, int index){
                  if(index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel.videos[index - 1];
                  return _buildVideo(video);
                }
            )
                : Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
