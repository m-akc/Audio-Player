import 'package:flutter_riverpod/flutter_riverpod.dart';

final appBarProvider = StateNotifierProvider<AppPro, Map<String,dynamic>>((ref) { // отслеживаем навел ли пользователь мышку на кнопку или нет
  return AppPro();
});
class AppPro extends StateNotifier<Map<String,dynamic>> {
   AppPro() : super(mystate);
static Map<String,dynamic> mystate = {
  'title': '',
  'darkmode':false,
  'lyrics':false,
  };
 String title = '';
 void changeAppBarTitle(String value){
  title = value;
  state = _changeState('title', title);
 }
 ///////////////////////////////////////////////////////////////////
 void enableDarkAppBar(bool value){
  state = _changeState('darkmode', value);
 }
 ///////////////////////////////////////////////////////////////////
 bool lyrics = false;
 void loadLyrics(bool value){
 lyrics = value;
 state = _changeState('lyrics', value);
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