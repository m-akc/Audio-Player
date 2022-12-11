

import 'dart:async';
import 'dart:math';
import '../bass/bass.dart';
import '../bass/basswasapi.dart';
import '../helper.dart';
import '../player/init.dart';
import '../player/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/settings.dart';

class Clock extends StateNotifier<Map<String,dynamic>> {
  Clock() : super(mystate) {
    // каждые 200мс - обновлять состояние.
    timer = Timer.periodic(  const Duration(milliseconds: 200), (Timer t) {
      // обновляем состояние
state = _changeState('slide', MP.currPos().toDouble());

      if(MP.currPos() != MP.trackLen())
      {
    updatePlayer();
     }
   //    if(!Settings.nextsong)
  //  {
//t.cancel();
 //   }
    });
  }
 late final Timer timer;
static Map<String,dynamic> mystate ={
  'slide':MP.currPos().toDouble(),
  'vol':Settings.vol,
  'button': false,
  'darkmode':false
  };
  //////////////////////////////////////////////////состояние цвета кнопок//////////////////////////////////////////////////////////
List<bool> hoverList = [false,false,false,false,false,false,false,false,false,false];
void changeColor(int index, bool value)
 {
  state = _changeState('button', value);
  hoverList[index] = value;
}
////////////////////////////////////////////////состояние главного слайдера//////////////////////////////////////////////////////////
void changeSlide(double value){
Settings.pos = value;
state = _changeState('slide', value);
}
/////////////////////////////////////////////////состояние общий метод//////////////////////////////////////////////////////
Map<String,dynamic> _changeState(String stateName,dynamic v)
{
state = state.map((key, value) { 
  if(key == stateName)
  {
  return MapEntry(key, v);
  }
  return  MapEntry(key, value);
  });
return state;
}
// Функция проверяет закончилась ли песня...И если закончилась загружает следующую
void updatePlayer(){
  if(Settings.data[Settings.listCount].isNotEmpty)
  {
   track(null).selected = false;
  
  switch(Settings.options)
  {
    case PlayerOptions.loop:
      {
if (MP.currPos()> (track(null).cue ? MP.trackLeninBytes(track(null).endTime == 0 ? MP.trackLenInSeconds():track(null).endTime.toDouble()): MP.trackLen()-100000))
{
   MP.playBass(MP.restart);
}
      }
      break;
    case PlayerOptions.shuffle:
      {
         if (MP.currPos()> (track(null).cue ? MP.trackLeninBytes(track(null).endTime == 0 ? MP.trackLenInSeconds():track(null).endTime.toDouble()): MP.trackLen()-100000))
  {
      var rnd = Random();
      var number = rnd.nextInt(Settings.data[Settings.listCount].length);
      Settings.songCount != number ?
       Settings.songCount = number :   MP.playBass(MP.restart);
  }
      }
      break;
    case PlayerOptions.standart:
      {
      if ((MP.currPos()> (track(null).cue ? MP.trackLeninBytes(track(null).endTime == 0 ? MP.trackLenInSeconds():track(null).endTime.toDouble()): MP.trackLen()-100000)) && Settings.songCount<Settings.data[Settings.listCount].length-1)
  {
     Settings.songCount++;
  }
      }
      break;
  }
   track(null).selected = true;
  }
}
//////////////////////////////состояние звука//////////////////////////////////////////

void changeVol(double value) // включаем или выключаем Эксклюзив мод
 {
  Settings.vol = value;
 !Settings.mute ? state = _changeState('vol', value) : state = _changeState('vol', 0.0);
 if(!Settings.mute)
 {
   !Settings.exclusive ?
     Bass.api.BASS_ChannelSetAttribute(MP.basshandle, BASS_ATTRIB_VOL, state['vol']!) : Bass.wapi.BASS_WASAPI_SetVolume(BASS_WASAPI_CURVE_LINEAR, state['vol']!);
 }
}
void soundOff(){
  Settings.mute = !Settings.mute;

    if(Settings.exclusive)
            {
            Settings.mute ? Bass.wapi.BASS_WASAPI_SetMute(BASS_WASAPI_CURVE_WINDOWS, 1) : Bass.wapi.BASS_WASAPI_SetMute(BASS_WASAPI_CURVE_WINDOWS, 0);
            }
            else{
              Settings.mute ? Bass.api.BASS_ChannelSetAttribute(MP.basshandle, BASS_ATTRIB_VOL, 0.0) : Bass.api.BASS_ChannelSetAttribute(MP.basshandle, BASS_ATTRIB_VOL, 0.5);
            }

}
//////////////////loop Трэка///////////////////////////
//bool loopState = false;
void enableLoop(){
  Settings.options != PlayerOptions.loop ?
  Settings.options = PlayerOptions.loop : Settings.options = PlayerOptions.standart;
 // Settings.loop = !Settings.loop;
 // loopState = Settings.loop;
}
////////////////////////////////////////////////////////////////////////
//bool shuffleState = false;
void enableShuffle(){
   Settings.options != PlayerOptions.shuffle ?
   Settings.options = PlayerOptions.shuffle : Settings.options = PlayerOptions.standart;
 // Settings.shuffle = !Settings.shuffle;
 // shuffleState = Settings.shuffle;
}
////////////////////////////////////////////////////////////////////////
void enableDarkSlider(bool value){
  state = _changeState('darkmode', value);
}
////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
final clockProvider = StateNotifierProvider<Clock, Map<String,dynamic>>((ref) {
  return Clock();
});
