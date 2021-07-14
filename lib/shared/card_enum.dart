import 'package:gamers_and_content_creators/screens/home/cards/anime_card.dart';
import 'package:gamers_and_content_creators/screens/home/cards/bio_card.dart';
import 'package:gamers_and_content_creators/screens/home/cards/soundcloud_card.dart';
import 'package:gamers_and_content_creators/screens/home/cards/twitch_card.dart';
import 'package:gamers_and_content_creators/screens/home/cards/video_game_card.dart';
import 'package:gamers_and_content_creators/screens/home/cards/youtube_card.dart';
import 'package:flutter/material.dart';
import 'package:gamers_and_content_creators/screens/home/preview_cards/preview_cards.dart';

enum DuwoCard{
  youtube,
  twitch,
  bio,
  favoriteGames,
  favoriteAnime,
  soundCloud,
}

Widget enumToWidget(String card, {String channelId, String bioTitle, String bioBody} ){
  switch(card){
    case 'Youtube Card':
      return YoutubeCard(channelId: channelId);
      break;
    case 'Twitch Card':
      return TwitchCard();
      break;
    case 'Bio Card':
      return BioCard(bioTitle: bioTitle, bioBody: bioBody);
      break;
    case 'Video Game Card':
      return FavoriteVideoGamesCard();
      break;
    case 'Anime Card':
      return AnimeCard();
      break;
    case 'Soundcloud Card':
      return SoundcloudCard();
      break;
  }
}

Widget stringToPreview(String card){
  switch(card){
    case 'Youtube Card':
      return YoutubePreviewCard();
      break;
    case 'Twitch Card':
      return TwitchPreviewCard();
      break;
    case 'Bio Card':
      return BioPreviewCard();
      break;
    case 'Video Game Card':
      return VideoGamePreviewCard();
      break;
    case 'Anime Card':
      return AnimePreviewCard();
      break;
    case 'Astrology':
      return AstrologyPreviewCard();
      break;
    case 'Soundcloud Card':
      return SoundcloudPreviewCard();
      break;
  }
}
final List<dynamic> allCards = ['Youtube Card', 'Twitch Card', 'Bio Card', 'Video Game Card', 'Anime Card', 'Astrology', 'Soundcloud Card'];