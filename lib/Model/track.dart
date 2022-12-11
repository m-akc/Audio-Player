// ignore_for_file: avoid_print
//import 'package:ffi/ffi.dart';
import '../dll.dart';
import 'package:ffi/ffi.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
//import 'package:genius_lyrics/models/album.dart';
//import 'package:genius_lyrics/models/artist.dart';
import 'package:genius_lyrics/models/song.dart';

//import '../myffi.dart';
import '../tag.dart';

Genius genius = Genius(accessToken: 'fcJMSWzjsIqxs-C4hJrwlU5MswNpWah-EWFDs4CZ7IyuWBgLtoVH3fDG57o7k5hy');
class Track{
static Tag tag = Tag(Dll.tagapi!);
String? picture; // Обложка альбома
String? album;
String? artist; // исполнитель
String? title; // название песни
String path; // Место расположения трека на диске
String? ext;
int? len; // формат файла
int? bitrate; // битрейт файла
bool isFavorire = false; // добавлен ли трек в "любимые"
bool selected = false;
bool edit = false;
String? lyrics;
int startTime = 0;
int endTime = 0;
bool cue = false;
  
   // Загружаем слова песни. И редактируем финальный результат(очищаем от мусора)
   Future<String?> getLyrics()  async {
  
     String? lyrics;
      if(artist != '' && title != '')
      {
    String searchString = 'Lyrics';
    String endofTitle = '(';
    int titleIndex = title!.indexOf(endofTitle);
    if(titleIndex > 1)
    {
    title = title!.substring(0,titleIndex);
    }
   
Song? song = await genius.searchSong(artist: artist, title: title);

if(song != null && song.lyrics != '' && song.lyrics != null )
{
  print('checking lyrics ');
  var index = song.lyrics!.indexOf(searchString); //+6
  print(index);
  lyrics = song.lyrics!.substring(index+6,song.lyrics!.length);
if (lyrics.substring(lyrics.length-5,lyrics.length) == 'Embed')
{
lyrics = lyrics.substring(0,lyrics.length-5);
for(;_isNumeric(lyrics?.substring(lyrics.length-1,lyrics.length))==true;lyrics = lyrics!.substring(0,lyrics.length-1))
{print('deleted garbage!');}
}
}else{lyrics = 'Поиск не дал результатов';}
      }
else{ lyrics = 'Поиск не дал результатов';}
return lyrics;
}
 ////////////////////////////////////////////////////////////////////////////////
 void editArtist(String art){
   var f = tag.taglib_file_new_utf16(path.toNativeUtf16().cast());
   var metadata = tag.taglib_file_tag(f);
  tag.taglib_tag_set_artist(metadata, art.toNativeUtf8().cast());
  tag.taglib_file_save(f);
   tag.taglib_tag_free_strings();
   tag.taglib_file_free(f);
 }
  void editAlbum(String art){
   var f = tag.taglib_file_new_utf16(path.toNativeUtf16().cast());
   var metadata = tag.taglib_file_tag(f);
  tag.taglib_tag_set_album(metadata, art.toNativeUtf8().cast());
  tag.taglib_file_save(f);
   tag.taglib_tag_free_strings();
   tag.taglib_file_free(f);
 }
  void editSongName(String name){
   var f = tag.taglib_file_new_utf16(path.toNativeUtf16().cast());
   var metadata = tag.taglib_file_tag(f);
  tag.taglib_tag_set_title(metadata, name.toNativeUtf8().cast());
  tag.taglib_file_save(f);
   tag.taglib_tag_free_strings();
   tag.taglib_file_free(f);
 }
 ////////////////////////////////////////////////////////////////////////////////
   //Конструктор
Track(this.path){
  var f = tag.taglib_file_new_utf16(path.toNativeUtf16().cast());
var metadata = tag.taglib_file_tag(f);
var audio = tag.taglib_file_audioproperties(f);

  artist = tag.taglib_tag_artist(metadata).cast<Utf8>().toDartString();
   title = tag.taglib_tag_title(metadata).cast<Utf8>().toDartString();
   album = tag.taglib_tag_album(metadata).cast<Utf8>().toDartString();
    bitrate = tag.taglib_audioproperties_bitrate(audio);
    len = tag.taglib_audioproperties_length(audio);
    ext = checkFormat(path);
   tag.taglib_tag_free_strings();
   tag.taglib_file_free(f);
}
Track.custom({required this.path,this.artist,this.title,this.album, this.len, this.ext,required this.startTime,required this.endTime, required this.cue});
}


 
  bool _isNumeric(String? s) {
  if(s == null) {
    return false;
   
  }
  return double.tryParse(s)!=null ? true : false;
}

 // проверка формата файла для определения дальнейших операций
  String checkFormat(String path)
   {
      if(path.endsWith('.mp3')){return 'mp3';}
      if(path.endsWith('.ogg')){return 'ogg';}
      if(path.endsWith('.flac')){return 'flac';}
      if(path.endsWith('.ape')){return 'ape';}
      if(path.endsWith('.aac')) {return 'aac';}
      if(path.endsWith('.mp2')){return 'mp2';}
      if(path.endsWith('.wav')){return 'wav';}
      if(path.endsWith('.mp4')){return 'mp4';}
      if(path.endsWith('.m4a')){return 'm4a';}
      if(path.endsWith('.m4b')){return 'm4b';}
      if(path.endsWith('.m4p')){return 'm4p';}
      if(path.endsWith('.m1a')){return 'm1a';}
      if(path.endsWith('.wma')){return 'wma';}
      if(path.endsWith('.cue')){return 'cue';}
       if(path.endsWith('.m3u')){return 'm3u';}
      if(path.endsWith('.wv')){return 'wv';}
      if(path.endsWith('.opus')){return 'opus';}
return 'null';
   }