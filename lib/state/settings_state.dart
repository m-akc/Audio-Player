import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper.dart';
import '../player/init.dart';
import '../player/player.dart';
import '../settings.dart';

final settingsProvider = StateNotifierProvider<SPro, Map<String,dynamic>>((ref) { // отслеживаем навел ли пользователь мышку на кнопку или нет
  return SPro();
});
class SPro extends StateNotifier<Map<String,dynamic>> {
   SPro() : super(mystate);
static Map<String,dynamic> mystate = {
  'vst': Settings.vstEq,
  'eq':Settings.isFX,
  'exc': Settings.exclusive,
  'darkmode':false,
  'eqval': 0.0
  };
  ///////////////////////////////////VST////////////////////////////////////
void enableVst(bool value)
{
Settings.vstEq = value;
MP.loadMusic(Settings.data[Settings.listCount]);
state = _changeState('vst', value);
}
///////////////////////////////////////EQ////////////////////////////////
void enableEQ(bool value)
 {
  Settings.isFX = value;
  state = _changeState('eq', value);
  EQ.initFX(Settings.isFX);
}
void changeEQup(double value, int i)
  {
   EQ.updateFX(i, PlayerFx.fxUp);
  state = _changeState('eqval', value);
}
void changeEQdown(double value, int i) async
  {
   EQ.updateFX(i, PlayerFx.fxDown);
  state = _changeState('eqval', value);
}
////////////////////////////////////////////////////////////////////////
void enableDarkMode(bool value){
Settings.darkTheme = value;
state = _changeState('darkmode', value);
}
 ////////////////////////////////////mode///////////////////////////////
 //bool exclusive = false;
 void changeMode(bool value){
//  exclusive = value;
  Settings.exclusive = value;
  state = _changeState('exc', value);
  Bass.init();
  MP.loadMusic(Settings.data[Settings.listCount]);
 }
 ///////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////
}