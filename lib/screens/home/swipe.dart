import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/cards/youtube_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamers_and_content_creators/screens/home/home.dart';
import'package:gamers_and_content_creators/models/channel_model.dart';
import 'package:gamers_and_content_creators/models/video_model.dart';
import 'package:gamers_and_content_creators/services/api_service.dart';
import 'package:gamers_and_content_creators/screens/home/subscreens/video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> with AutomaticKeepAliveClientMixin<Swipe> {
  final double cardHeight = 480;
  final double cardWidth = 360;
  final _controller = PageController(
    initialPage: 0,
  );

  //FakeData//
  final List <String> pics = [
    'assets/Bridget.png',
    'assets/Chives.png',
    'assets/Jack Circle.png',
    'assets/MooShu.png',
    'assets/Noah.png',
    'assets/Shu.png'
  ];
  final List <String> setups = [
    'assets/clean pc setup.jpg',
    'assets/pc setup 2.jpg',
    'assets/pc setup 3.jpg',
    'assets/pc setup 4.jpg',
    'assets/pc setup 5.jpg',
    'assets/pc setup 6.jpg'
  ];
  final List <String> names = [
    'Bridget',
    'Chives',
    'Jack',
    'MooShu',
    'Noah',
    'Shu'
  ];
  final List <String> ages = [
    '27',
    '31',
    '26',
    '64',
    '24',
    '32'
  ];
  final List <String> channels = [
    'UCH5mi85eqEm-bOLvc69Lpaw',//'UCvYUyKg7wDj760PippmWhig',
    'UCBa659QWEk1AI4Tg--mrJ2A',
    'UCgFvT6pUq9HLOvKBYERzXSQ',
    'UCxzC4EngIsMrPmbm6Nxvb-A',
    'UCq3Wpi10SyZkzVeS7vzB5Lw',
    'UCq6aw03lNILzV96UvEAASfQ',
  ];
  int personIndex = 0;
  ////

  Channel _channel;
  bool _isLoading = false;
  String currentChannelId; //just to launch the channel

  @override
  void initState(){
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: channels[personIndex]);
    setState((){
      _channel = channel;
    });
  }

  _buildProfileInfo(){
    return GestureDetector(
      onTap: () {
        currentChannelId = channels[personIndex];
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage(setups[personIndex]),
          colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            expandedHeight: 260.0,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            pinned: false,
            floating: false,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(pics[personIndex]),
              title: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        if(personIndex < 5){
                          personIndex += 1;
                          setState((){});
                          print(personIndex);
                          _initChannel();
                        }
                      else{
                        personIndex = 0;
                        setState((){});
                        print(personIndex);
                        _initChannel();
                        }
                      },
                      child: Icon(Icons.remove),
                      backgroundColor: Colors.pink[500],
                    ),
                  ),
                  //SizedBox(width:50),
                  SizedBox(
                    width:50,
                    height:50,
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: (){
                        if(personIndex < 5){
                          personIndex += 1;
                          setState((){});
                          print(personIndex);
                          _initChannel();
                        }
                        else{
                          personIndex = 0;
                          setState((){});
                          print(personIndex);
                          _initChannel();
                        }
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.pink[500],
                    ),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.all(20),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return Container(
                child: Column(
                  children:<Widget> [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50,50,50,0.6),//Color.fromRGBO(100,0,150,1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //SizedBox(width: 30),
                            Text(
                              names[personIndex],
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            //SizedBox(width: 190),
                            Text(
                              'Age: ' + ages[personIndex],
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 550,
                      color: Colors.black,
                      child: Center(
                        child: SizedBox(
                          height: cardHeight,
                          width: cardWidth,
                          child: PageView(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            children:[
                              YoutubeCard(channelId: channels[personIndex]),
                              // Container(
                              //   height: cardHeight,
                              //   width: cardWidth,
                              //   decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.white, width: 4),
                              //     borderRadius: BorderRadius.circular(20),
                              //     color: Color.fromRGBO(70, 0, 0, 1),
                              //   ),
                              //   child: Column( // YOUTUBE CARD
                              //     children: [
                              //       Container(
                              //         child: Image.asset('assets/YoutubeLogo.png',scale: 8),
                              //       ),
                              //       Container(
                              //         height:400,
                              //         child: _channel != null
                              //             ?ListView.builder(
                              //             itemCount: 1 + _channel.videos.length,
                              //             itemBuilder: (BuildContext context, int index){
                              //               if(index == 0) {
                              //                 return _buildProfileInfo();
                              //               }
                              //               Video video = _channel.videos[index - 1];
                              //               return _buildVideo(video);
                              //             }
                              //           )
                              //         : Center(
                              //           child: CircularProgressIndicator(
                              //             valueColor: AlwaysStoppedAnimation<Color>(Colors.red)
                              //             ),
                              //           ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Container( //TWITCH
                                height: cardHeight,
                                width: cardWidth,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 4),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(50, 0, 80, 1),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Image.asset('assets/TwitchLogo.png',scale: 6),
                                    ),
                                  ],
                                ),
                              ),
                              // Container( //old twitch card
                              //   height: cardHeight,
                              //   width: cardWidth,
                              //   decoration: BoxDecoration(
                              //     color: Colors.orange,
                              //     borderRadius: BorderRadius.circular(15),
                              //     image: DecorationImage(
                              //       image: AssetImage('assets/Twitch Card.png'),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                height: cardHeight,
                                width: cardWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  border: Border.all(color: Colors.white, width: 4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Bio',
                                      style: GoogleFonts.lato(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: cardHeight,
                                width: cardWidth,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height:40,
                      color: Colors.grey[900],//Color.fromRGBO(100,0,150,1),
                    ),
                  ],
                ),
              );
            },
            childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
