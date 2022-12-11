import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper.dart';
import '../services/cover.dart';
import '../settings.dart';

final coverProvider = StateNotifierProvider<CPro, Map<String,dynamic>>((ref) { // отслеживаем навел ли пользователь мышку на кнопку или нет
  return CPro();
});
class CPro extends StateNotifier<Map<String,dynamic>> {
   CPro() : super(mystate);
static Map<String,dynamic> mystate = {
  'cover': '',
  'darkmode':false,
  };
 String cover = '';
 void changeCover(){
    if(Settings.data[Settings.listCount].isNotEmpty)
  {
    if(track(null).artist!.isNotEmpty)
    {
Cover.getCover(track(null).artist!).then((response) {
  cover = response.data['data'][0]['artist']['picture_xl'] as String;
 state = _changeState('cover', cover);
 });
    }
  }
 }
 ///////////////////////////////////////////////////////////////////
 
 ///////////////////////////////////////////////////////////////////
 void enableDarkCover(bool value){
  state = _changeState('darkmode', value);
 }
 ////////////////////////////////////////////////////////////////////
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




final homeProvider =  StateNotifierProvider<HPro, int>((ref) { 
  return HPro();
});
class HPro extends StateNotifier<int> {
   HPro() : super(0);
void changePage(int index) {
 state = index;
}
}