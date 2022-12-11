import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/helper.dart';

import '../Model/track.dart';
import '../player/player.dart';
import '../services/cover.dart';
import '../settings.dart';

final listProvider = StateNotifierProvider<ListPro, Map<String,dynamic>>((ref) { // отслеживаем навел ли пользователь мышку на кнопку или нет
  return ListPro();
});
class ListPro extends StateNotifier<Map<String,dynamic>> {
   ListPro() : super(mystate);
static Map<String,dynamic> mystate = {
  'search':Settings.showSearch, // показывать ли результаты поиска или нет
  'player': PlayerState, // состояние плеера
  'tracklist': Settings.data[Settings.listCount], // все плейлисты и все треки
  'songCount':Settings.songCount,                 // номер песни
  'selected': false,                              //выбран или нет
  'edit': false,                                  //редактируем или нет
  'list':Settings.listCount,                      // номер плейлиста
   'playlist': Settings.listOfCovers,             // лист картинок для плейлистов
  };
  /////////////////////////////////////////////////
  void showSearch(){
    state =  _changeState('search', Settings.showSearch);
  }
  /////////////////////////////////////////////////
   void addPlaylistCover (int listIndex){
   if(Settings.data[Settings.listCount].isNotEmpty)
  {
    if(track(0).artist!.isNotEmpty)
    {

Cover.getCover(track(0).artist!).then((response) { 
  Settings.listOfCovers.removeAt(listIndex);
  Settings.listOfCovers.insert(listIndex,response.data['data'][0]['artist']['picture_medium'] as String);
  Settings.playlistPic[listIndex] = true;
state = _changeState('playlist', Settings.listOfCovers);
    });
    }
  }
 }
void changePlaylist(int index){
  Settings.listCount = index;
    if(Settings.data[Settings.listCount].isNotEmpty)
   {
   // Settings.songCount = 0;
track(null).selected = false;

MP.changeState(PlayerState.stopped);
//Settings.songCount = 0;
   }
   for(int i=0;i<Settings.selectedList.length;i++)
  {
    Settings.selectedList[i] = false;
  }
  Settings.selectedList[index] = true;
  state = _changeState('list', index);
   Settings.songCount = 0;
}
////////////////////////////////////////////////////////////////////////////////////////
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
void changeTracklist(List<Track> value)
 {
  state = _changeState('tracklist', value);
}
void removeTrack(int count)
{
Settings.data[Settings.listCount].removeAt(count);
state = _changeState('tracklist', Settings.data[Settings.listCount]);
}
void addTrack(Track track){
  if (Settings.showSearch)
  {
  Settings.data[0].add(track);
  state = _changeState('tracklist', Settings.data[0]);
  }
}
//////////////////////////////////////////////////////////////////////
void editSong(int index,bool value){
  track(index).edit = value;
  state = _changeState('edit', value);
}
//////////////////////////////////////////////////////////////////////
void changeSong(int index){
 /* if(Settings.songCount != index)
  {
    print('test ne ravno');
   for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    track(i).selected = false;
  }
track(index).selected = true;
//state = _changeState('songCount', index);
Settings.songCount = index;
  }
  else{
    print('ravno');
    state = _changeState('songCount', index);
    MP.changeState(PlayerState.playing);
     if(Settings.data[Settings.listCount].isNotEmpty)
  {
      if (track(null).cue)
    {
   MP.setPosition(track(null).startTime);
    }
  }
  }*/
  print('change');
  if(Settings.songCount!=index)
  {
    Settings.songChangedbyButton = true;
  }
   for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    track(i).selected = false;
  }
  Settings.songCount = index;
    MP.changeState(PlayerState.playing);
     if (track(null).cue)
    {
   MP.setPosition(track(null).startTime);
    }
     track(null).selected = true;
      state = _changeState('songCount', index);
}
////////////////////////////////////////////////////
void select(int index){
  for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    track(i).selected = false;
  }
track(index).selected = true;
state = _changeState('songCount', index);
}
////////////////////////////////////////////////////

void rightClick(int index, bool value){
 if(Settings.data[Settings.listCount].isNotEmpty)
 {
 if(value == false)
  {
  for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    track(i).selected = false;
  }
track(index).selected = true;
state = _changeState('selected', value);
  }
  else{
    state = _changeState('selected', value);
  }
 }
}
////////////////////////////////////////////////////
void stopped(){
   MP.changeState(PlayerState.stopped);
 //state = _changeState('player', PlayerState.stopped);
}
void next(){
  if(Settings.data[Settings.listCount].isNotEmpty)
  {
     MP.changeState(PlayerState.next);
     track(null).selected = true;
     state = _changeState('player', PlayerState.next);
  }
}
void prev(){
   if(Settings.data[Settings.listCount].isNotEmpty)
  {
    MP.changeState(PlayerState.previous);
     track(null).selected = true;
     state = _changeState('player', PlayerState.previous);
  }
}
void paused(){
  MP.changeState(PlayerState.paused);
}
void playing(){
   for(int i=0;i<Settings.data[Settings.listCount].length;i++)
  {
    track(i).selected = false;
  }
     MP.changeState(PlayerState.playing);
     track(null).selected = true;
      state = _changeState('player', PlayerState.playing);
}
}