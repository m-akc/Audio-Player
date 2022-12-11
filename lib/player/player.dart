library bass_audio;

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:smaq/bass/bassape.dart';
import 'package:smaq/bass/bassopus.dart';
import 'package:smaq/bass/basswv.dart';
import 'package:smaq/dll.dart';
import '../Model/track.dart';
import '../bass/bass.dart';
import '../bass/bassvst.dart';
import '../bass/basswasapi.dart';
import '../helper.dart';
import '../settings.dart';
import 'init.dart';

part 'equalizer.dart';
class MP{
  static var vst = Bassvst(Dll.vstapi!);
  static var opus = Opus(Dll.opusapi!);
  static var wv = Basswv(Dll.wvapi!);
  static var ape = Bassape(Dll.apeapi!);
  static int basshandle = 0;
  static int dsp = 0;
  static String eqPath = '${runPath}geq.dll';
  static String file = '';
  static int restart = 1;
//////////////////////////////////
static int setPosition(int seconds){
  var bytes = trackLeninBytes(seconds.toDouble());
  return   Bass.api.BASS_ChannelSetPosition(basshandle, bytes, BASS_POS_BYTE);
}
//////////////////////////////////////
static int trackLeninBytes(double pos){
  var byte = Bass.api.BASS_ChannelSeconds2Bytes(basshandle, pos);
   return byte == -1 ? 0 : byte;
}
////////////////////////////////////
static double trackLenInSeconds() {// Длина всего трека в секундах
  return Bass.api.BASS_ChannelBytes2Seconds(basshandle,trackLen());
}
static double currPosinSeconds({int? pos}) { // текущая позиция трека в секундах
  return Bass.api.BASS_ChannelBytes2Seconds(basshandle, Settings.position ? !track(null).cue ? currPos() : currPos() - MP.trackLeninBytes(track(null).startTime.toDouble()) : pos!);
}
static int trackLen()  { // длина трека в байтах
var pos =  Bass.api.BASS_ChannelGetLength(basshandle, BASS_POS_BYTE );
 return pos == -1 ? 0 : pos; 
}
static int currPos(){ // сколько байтов уже прочитано.
var pos = Bass.api.BASS_ChannelGetPosition(basshandle,BASS_POS_BYTE);
  return pos == -1 ? 0 : pos;
}
///////////////////////////////////
static void loadMusic(List<Track> list) { //  Загрузка треков и создание Эквалайзера.
  Bass.api.BASS_ChannelFree(basshandle);
  Bass.api.BASS_StreamFree(basshandle);
  Bass.wapi.BASS_WASAPI_Free();
  
 basshandle = _createTrack(list);
 Bass.api.BASS_ChannelSetAttribute(basshandle, BASS_ATTRIB_VOL, Settings.vol);
if( Settings.exclusive)
{
Bass.wapi.BASS_WASAPI_Init(-1, 44100, 0, BASS_WASAPI_EXCLUSIVE|BASS_WASAPI_EVENT, 0.1, 0, WASAPIPROC_BASS, Pointer.fromAddress(basshandle));
print('exclusive mode');
}
if(Settings.vstEq)
{
dsp = vst.BASS_VST_ChannelSetDSP(basshandle, eqPath.toNativeUtf8().cast(), BASS_VST_KEEP_CHANS, 1);
}
  
  try{
    Bass.check(basshandle);
  } 
      catch(_){
  
         var err = 'ERROR createBass() CODE:${Bass.myErr}';
    saveError(err);
      print(err);
  }
  print ('createD');
    EQ.initFX(Settings.isFX);
}

static int _createTrack(List <Track> list){
   print('loading track');
 //  saveError('inside loadtrack()');
   // Очищаем хвосты, Загружаем трек и(если надо) Эффекты(Эквалайзер итд)


     WasapiState state;
   Settings.exclusive ? state = WasapiState.exclusive : state = WasapiState.normal;
  
 late int handle;
 // В зависимости от формата файла загружаем его соответствующим образом.
 if(list.isNotEmpty && !Settings.yandexD)
 {
  print('vnutri load');
  file =  list[Settings.songCount].path;
  switch (list[Settings.songCount].ext) {
     case 'wv':
    {
    handle = wv.BASS_WV_StreamCreateFile(0, file.toNativeUtf16().cast<Void>(), 0, 0,state.flags);
    print('wv');
 //    saveError('wv');
    }
      break;
    case 'opus':
    {
    handle = opus.BASS_OPUS_StreamCreateFile(0, file.toNativeUtf16().cast<Void>(), 0, 0,state.flags);
    print('opus');
 //    saveError('opus');
    }
      break;
    case 'ape':
    {
    handle = ape.BASS_APE_StreamCreateFile(0, file.toNativeUtf16().cast<Void>(), 0, 0,state.flags);
    print('ape');
 //    saveError('ape');
    }
      break;
    default: 
    {
      print('def $file');
    handle = Bass.api.BASS_StreamCreateFile(0, file.toNativeUtf16().cast<Void>(), 0, 0,state.flags);
    }
    break;
  }

 }
  // yandexD ? handle = Bass.api.BASS_StreamCreateURL(url.toNativeUtf16().cast(), 0,state.yandexDflags, nullptr, nullptr) : 
  //         handle = (file=='') ? -1 : handle;
//Bass.api.BASS_PluginLoad('bassopus.dll'.toNativeUtf16().cast(), BASS_UNICODE);
//bassApi.BASS_PluginLoad('basswebm.dll'.toNativeUtf16().cast(), BASS_UNICODE);
 //   yandexD ? handle = await loadTrackUrl(2) : //opus.BASS_OPUS_StreamCreateURL(ytUrl!.toNativeUtf16().cast(), 0,state.yandexDflags, nullptr, nullptr) : 
  //         handle = (file==null) ? -1 : handle;
        try{
    Bass.check(handle);
  }
  catch(_){
    // Printing error
    var err = 'ERROR LOADTRACK() CODE:${Bass.myErr}';
    saveError(err);
      print(err);
  }
  return handle;
  }
//////////////////////////////////////////////

static void playBass(int restart) {// запускаем трек.
  int play;
  if(Settings.exclusive)
  {
    if(Bass.wapi.BASS_WASAPI_IsStarted()==1)
    {
     loadMusic(Settings.data[Settings.listCount]);
    }
    print('play exclusive');
    play = Bass.wapi.BASS_WASAPI_Start();
    
  }else{
    print('play normal');
  play = Bass.api.BASS_ChannelPlay(basshandle, restart);
  }
  
   try{
    Bass.check(play);
  }
  catch(_){
    // Printing error
          var err = 'ERROR  playBass() CODE:${Bass.myErr}';
    saveError(err);
      print(err);
  }
}
static void pauseBass() {// ставим трек на паузу
print('paused');
  int pause;
  if(Settings.exclusive ? Bass.wapi.BASS_WASAPI_IsStarted()==1 : Bass.api.BASS_ChannelIsActive(basshandle)!=3 && Bass.api.BASS_ChannelIsActive(basshandle)!=0)
  {
  restart = 0;
   Settings.exclusive ? pause = Bass.wapi.BASS_WASAPI_Stop(1) : pause =  Bass.api.BASS_ChannelPause(basshandle);
  
   try{
    Bass.check(pause);
  }
  catch(_){
    // Printing error
    
         var err = 'ERROR  pauseBass() CODE:${Bass.myErr}';
    saveError(err);
      print(err);
  
  }
  }
}
////////////////////////////////////////////////////////////////
static Future<void> sliderChanged(SliderState state,int value)async {
switch(state) // управляем состоянием слайдера трека.
{
  case SliderState.start:
    {
      Settings.position = false;
      if( Settings.exclusive==false ? Bass.api.BASS_ChannelIsActive(basshandle)==1 : Bass.wapi.BASS_WASAPI_IsStarted()==1)
      {changeState(PlayerState.paused);}else{restart =1;}
    }
    break;
  case SliderState.end:
    {
                Bass.api.BASS_ChannelSetPosition(basshandle, value, BASS_POS_BYTE);
                Settings.position = true;

        if(Bass.api.BASS_ChannelIsActive(basshandle)==3 && restart == 0 || Bass.wapi.BASS_WASAPI_IsStarted()==0 && restart==0)
  {changeState(PlayerState.playing);}else{restart = 0;}
    }
    break;
}
}
////////////////////
// Меняем состояние плеера.
static void changeState(PlayerState state) async {
  switch (state) // управляем состоянием плеера.
  {
    case PlayerState.playing: {        // PLAY
     if(Settings.data[Settings.listCount].isNotEmpty) {
       if(file != Settings.data[Settings.listCount][Settings.songCount].path) 
       {
         loadMusic(Settings.data[Settings.listCount]);
       }
         playBass(restart);
           restart = 1;
     }    
    }
    break;
    case PlayerState.stopped:{ //  СТОП
   
   MP.setPosition(track(null).startTime);
   MP.changeState(PlayerState.paused);
   // }
     // Settings.nextsong = false;
    }break;
    case PlayerState.paused:{ // ПАУЗА
      pauseBass();
    }break;
    case PlayerState.next:    // ВПЕРЕД
      {
            if(Settings.data[Settings.listCount].isNotEmpty && Settings.songCount < Settings.data[Settings.listCount].length-1)
            {
                for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    Settings.data[Settings.listCount][i].selected = false;
  }
              Settings.songCount++;
              }
      changeState(PlayerState.playing);
      }
      break;
    case PlayerState.previous:  // НАЗАД
    {
        
            if(Settings.data[Settings.listCount].isNotEmpty && Settings.songCount > 0)
            {
             for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    Settings.data[Settings.listCount][i].selected = false;
  }
              Settings.songCount--;
              }
    
           changeState(PlayerState.playing);
          
    }
      break;
  }
}

}