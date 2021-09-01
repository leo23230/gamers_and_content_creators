import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gamers_and_content_creators/shared/constants.dart';

class TwitchCard extends StatefulWidget {
  @override
  _TwitchCardState createState() => _TwitchCardState();
}

class _TwitchCardState extends State<TwitchCard> {
  final double cardHeight = 480;
  final double cardWidth = 360;

  @override
  Widget build(BuildContext context) {
    return Container( //TWITCH
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(cardRoundness),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(30, 0, 60, 1),
            Color.fromRGBO(60, 0, 120, 1),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Image.asset('assets/TwitchLogo.png',scale: 6),
                HtmlWidget(
                  '''
                  <body>
                    <!-- Add a placeholder for the Twitch embed -->
                    <text>hi there</text>
                    <script src= "https://player.twitch.tv/js/embed/v1.js"></script>
                    <div id="SamplePlayerDivID"></div>
                    <script type="text/javascript">
                      var options = {
                        width: 400,
                        height: 300,
                        video: "1078535113",
                      };
                      var player = new Twitch.Player("SamplePlayerDivID", options);
                      player.setVolume(0.5);
                    </script>
                  </body>
                  ''',
                //baseUrl: ,
                webViewJs: true,
                webView: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
