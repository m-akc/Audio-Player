import 'package:dio/dio.dart';

class Cover{
  static String baseUrl = 'https://api.deezer.com/search?q=';
  static final _dio = Dio();
static Future<Response> getCover(String artist) async {
  Response? response;
try{
  response = await _dio.get('${baseUrl}artist:"$artist"');
} catch(e){
 print(e);
}
return response!;
}

static Future<Response> getPlaylistCover(String album) async {
  Response? response;
try{
 response = await _dio.get('${baseUrl}album:"$album"');
} catch(e){
  print(e);
}
return response!;
}
}


