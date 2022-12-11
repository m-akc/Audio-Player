

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smaq/dll.dart';
import 'package:smaq/helper.dart';
import '../Model/track.dart';
import 'package:file_picker/file_picker.dart';

import '../settings.dart';

class FM{
   //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
static final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
 // String? _saveAsFileName;
 static  List<PlatformFile>? _paths;
 static List<PlatformFile>? get paths => _paths; // открыл ли пользователь аудио файлы или нет (геттер)
//  String? _directoryPath;
  static const String _extension = 'mp3, mp2, mp1, m1a, wav, ogg, aiff, aif, aifc, flac, m4a, m4b, m4p, mp4, aac, m3u, ape, cue, wma, opus, wv';
 // bool _isLoading = false;
//  bool _userAborted = false;
 static const bool _multiPick = true;
  static  const  FileType _pickingType = FileType.custom;
  //////////////////////////////////////////////////////
  static Future<void> openCue(String path) async {
    print('edit cue');
     File file = File(path);
     int index = 0;
     int songNumber = 1;
     String? artist,title,album,source = '';
     List<String> start = [];
    //  var track = Track.custom(path: path);
  var lines = await file.readAsLines();
  for (var line in lines)
  {
    index++;
   // if(line.startsWith('PERFORMER "') && index < 8)
   // { 
   //   print(index);
   //   artist = line.substring(11,line.length-1);
   // }
    if(line.startsWith('TITLE "') && index < 8)
    { 
       print(index);
      album = line.substring(7,line.length-1);
    }
     if(line.startsWith('FILE "') && index < 8)
    { 
       print(index);
      source = line.substring(6,line.length-6);
      var temp = path;
      if(source.endsWith('.flac') || source.endsWith('.opus') )
      {
      temp = temp.substring(0, path.length+1-source.length);
      } else if (source.endsWith('.wv')){
temp = temp.substring(0, path.length-1-source.length);
      }else{
        temp = temp.substring(0, path.length-source.length);
      }
      source = temp + source;
      
      print(source);
    }
     if(line.contains('TRACK '))
    { 
      print('gogogo');
    songNumber++;
    }
     if(line.contains('TITLE "') && index >= 8)
    { 
      title = line.substring(11,line.length-1);
    //  Settings.data[Settings.listCount].add(Track.custom(path: source!, artist:artist,title:title,album:album, ext:checkFormat(source)));
    }
      if(line.contains('PERFORMER "'))
    { 
    artist = line.substring(15,line.length-1);
    }
     if(line.contains('INDEX 01 '))
    { 
       start.add(line.substring(13,line.length-1));
       var i = Settings.data[Settings.listCount].length;
       if(songNumber >=3){
        track(i-1).endTime = parseDuration(start[songNumber-2]).inSeconds;
       }
       print(songNumber);
      Settings.data[Settings.listCount].add(
        Track.custom(path: source!, artist:artist,title:title,album:album, ext:checkFormat(source),
        startTime:parseDuration(start[songNumber-2]).inSeconds,
        endTime: 0, cue: true));
    }
  }
  }
  //////////////////////////////////////////////////////
static void saveM3u(List<Track> track){
 
File file = File('C:/save.m3u');
file.writeAsStringSync('#EXTM3U\n',mode: FileMode.append);
for (int i=0;i<track.length;i++)
{
file.writeAsStringSync('#EXTINF:${track[i].len},${track[i].artist} - ${track[i].title}\n',mode: FileMode.append);
file.writeAsStringSync('${track[i].path}\n',mode: FileMode.append);
}

}
static void openFiles( List<String> filepath) async {
   for(int i = 0;i<filepath.length;i++)
   {
if(checkFormat(filepath[i]).toLowerCase() != 'm3u' && checkFormat(filepath[i]) != 'cue' )
{ //saveError('ne m3u i ne cue');
  Settings.data[Settings.listCount].add(Track(filepath[i]));}
else if(checkFormat(filepath[i]) == 'cue')
{
await openCue(filepath[i]);

}
else
{ //saveError('m3u');
  File file = File(filepath[i]);
  var lines = await file.readAsLines();
  for (var line in lines)
  {
    if(!line.startsWith('#'))
    { Settings.data[Settings.listCount].add(Track(line));}
  }
}
   }
   print('files ready');
 }
static void _resetState() {
   //   _isLoading = true;
   //   _directoryPath = null;
   //   _fileName = null;
      _paths = null;
  //    _saveAsFileName = null;
   //   _userAborted = false;
  }
  static void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
 static void pickFiles() async {
    _resetState();
    try {
    //  _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        initialDirectory: runPath,
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions:_extension.replaceAll(' ', '').split(','),
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if(_paths != null)
    {
      List<String> temp = [];
      for(int i=0;i<_paths!.length;i++)
      {
        temp.add(_paths![i].path!);
      }
     // saveError('openfiles ${temp.first.toString()}');
       openFiles(temp);
  

           //   Settings.data[Settings.listCount][Settings.songCount].selected = true;
           //    Settings.data[Settings.listCount][Settings.songCount].isPlaying = true;
          //   MP.changeState(PlayerState.playing);
            // Settings.nextsong = true;

    }
    
     // MusicPlayer.songCount = _paths != null ? 0 : MusicPlayer.songCount;
    //  _isLoading = false;
// _fileName =
  //        _paths != null ? MusicPlayer.songlist.map((e) => e).toString() : _fileName;
     // _userAborted = _paths == null;
    
  }
      
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
