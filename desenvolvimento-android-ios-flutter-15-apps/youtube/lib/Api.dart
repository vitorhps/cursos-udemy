import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/Video.dart';

const YOUTUBE_API_KEY = "AIzaSyCGSyuLs7uxTnv2Roxj_SAKFdKOynl3ynk";
const CHANNEL_ID = "UCSfwM5u0Kce6Cce8_S72olg";
const BASE_URL = "https://www.googleapis.com/youtube/v3/";

class Api {

  Future<List<Video>> search(String query) async {

    http.Response response = await http.get(
      BASE_URL + "search"
        "?part=snippet"
        "&type=video"
        "&maxResults=20"
        "&order=date"
        "&key=$YOUTUBE_API_KEY"
        "&channelId=$CHANNEL_ID"
        "&q=$query"
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    List<Video> videos = jsonData["items"].map<Video>(
      (map) {
        return Video.fromJson(map);
      }
    ).toList();

    return videos;

  }

}