import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/settings.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:smaq/state/appbar_state.dart';

import '../helper.dart';
import '../services/fm.dart';
import '../state/cover_state.dart';
import '../state/slider_state.dart';
import '../state/tracklist_state.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';
//import '../helper.dart';


class MPappBar extends ConsumerWidget implements PreferredSizeWidget{
  const MPappBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
      int? strLen;
      int? searchLen;
  ref.watch(appBarProvider);
         if (Settings.data[Settings.listCount].isNotEmpty) // Считаем длину поисковой строки, чтобы не было коллизий
    {
      int art = Settings.data[Settings.listCount][Settings.songCount].artist?.length ?? 0;
      int title = Settings.data[Settings.listCount][Settings.songCount].title?.length ?? 0;
     strLen = art + title;
    }
    if ((strLen ?? 0) > 45)
    {
searchLen = 300;
    }
    else if ((strLen ?? 0) < 25)
    {
      searchLen = 600;
    }
    else{
      searchLen = 375;
    }
    return AppBar(
      title: Settings.data[Settings.listCount].isNotEmpty ? GestureDetector(
  onTap: () { 
   
    if(!ref.read(appBarProvider.notifier).lyrics)
    {
       ref.read(appBarProvider.notifier).loadLyrics(true);
    Settings.data[Settings.listCount][Settings.songCount].lyrics == null ? Settings.data[Settings.listCount][Settings.songCount].getLyrics().then((value) 
  { 
      Settings.data[Settings.listCount][Settings.songCount].lyrics = value;
         showDialog(
           context: context, 
           builder: (context) => AlertD(theme: Settings.darkTheme, lyrics:value!)
           );
           ref.read(appBarProvider.notifier).loadLyrics(false);
  }
           ) :  showDialog(
           context: context, 
           builder: (context) { 
             ref.read(appBarProvider.notifier).loadLyrics(false);
            return AlertD(theme: Settings.darkTheme, lyrics: Settings.data[Settings.listCount][Settings.songCount].lyrics!);}
           );
    }
            },
  child:Row(children:[Text(
          style:  TextStyle(color: Settings.darkTheme ? Colors.white : Colors.black),
          ref.read(appBarProvider.notifier).title),
          if(ref.read(appBarProvider.notifier).lyrics)
          const Padding(
            padding: EdgeInsets.only(left:10,top:5),
            child: SizedBox(width:10,height:10,child:CircularProgressIndicator(strokeWidth: 2,)),
          )])) : Text(
          style:  TextStyle(color: Settings.darkTheme ? Colors.white : Colors.black),
            'SMAQ PLAYER'),
        leadingWidth: searchLen.toDouble(),
        leading:SearchBarAnimation(
          searchBoxWidth: searchLen.toDouble(),
          hintText: 'Search',
                          textEditingController: TextEditingController(),
                          isOriginalAnimation: true,
                          enableKeyboardFocus: true,
                          onSaved: (v){
                                debugPrint('saved');
                          },
                          onChanged: (v){
                             debugPrint('changed');
                          },
                          onEditingComplete: (){
                         
                          },
                          onFieldSubmitted: (v){
                           debugPrint( 'field submitted');
                           for(int i=1;i<Settings.data.length;i++)
                           {
                           for (var track in Settings.data[i])
                           {
                             if (v.toString().toLowerCase().startsWith('a:'))
                             {
                           String text = v.toString().substring(2,v.toString().length);
                        if(track.artist!.toLowerCase().contains(text.toLowerCase()) || track.artist!.toLowerCase() == text.toLowerCase() )
                        {
                            if(Settings.search.isNotEmpty)
                          {
                            for(var t in Settings.search)
                            {
                              if(identical(track, t))
                              {
                                Settings.twin = true;
                              }
                            }
                          }
                           if(!Settings.twin)
                          {
                            Settings.showSearch = true;
                             ref.read(listProvider.notifier).addTrack(track);
                           ref.read(listProvider.notifier).changePlaylist(0);
                          
                          }
                            
                        }
                             }
                               if (v.toString().toLowerCase().startsWith('s:'))
                             {
                           String text = v.toString().substring(2,v.toString().length);
                        if(track.title!.toLowerCase().contains(text.toLowerCase()) || track.title!.toLowerCase() == text.toLowerCase() )
                        {
                          if(Settings.search.isNotEmpty)
                          {
                            for(var t in Settings.search)
                            {
                              if(identical(track, t))
                              {
                                Settings.twin = true;
                              }
                            }
                          }
                          if(!Settings.twin)
                          {
                           Settings.showSearch = true;
                            ref.read(listProvider.notifier).addTrack(track);
                             ref.read(listProvider.notifier).changePlaylist(0);
                         
                          }
                           
                     //  print(min());
                     //  print(max());
                     // Settings.search.add(track);
                        }
                             }
                           }
                           }
                           print('twin false');
                           Settings.twin = false;
                          },
                          onExpansionComplete: () {
                             Settings.showSearch = true;
                             ref.read(listProvider.notifier).showSearch();
                       //     debugPrint(
                        //        'do something ');
                       //   Settings.showSearch = true;
                       //   ref.read(listProvider.notifier).changePlaylist(0);
                          },
                          onCollapseComplete: () {
                            debugPrint(
                                'do something');
                              Settings.showSearch = false;
                               ref.read(listProvider.notifier).changePlaylist(1);
                      
                          },
                        ),
      //  centerTitle: true,
     
         backgroundColor: Colors.transparent, // <-- APPBAR WITH TRANSPARENT BG
            elevation: 0, // <-- ELEVATION ZEROED
        flexibleSpace: Container(
       //   child: const Moove(),
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const[
                0.33,
                1.0,
              ],
              colors: [
               Settings.darkTheme ? Colors.black : Colors.white,
               Settings.darkTheme ? const Color.fromARGB(0, 0, 0, 0) :  const Color.fromARGB(0, 255, 255, 255)
              ],
            )
          ),),
        actions: [
            IconButton(
                 iconSize: 19,
               hoverColor: Colors.transparent,
              color: const Color(0xFF805306),
              tooltip: 'Collection',
            onPressed: (){
            ref.read(homeProvider.notifier).changePage(0);
            }, 
            icon: const Icon(Icons.favorite)),
              IconButton(
                 iconSize: 19,
                 hoverColor: Colors.transparent,
                color: const Color(0xFF805306),
                 tooltip: 'Open Files',
            onPressed: (){
                 FM.pickFiles();
             ref.read(listProvider.notifier).changeTracklist(Settings.data[Settings.listCount]);
             
             ref.refresh(clockProvider);
             ref.read(clockProvider.notifier).changeVol(Settings.vol);
             if(Settings.data[Settings.listCount].isNotEmpty)
             {
              track(null).selected = true;
             }
             
            }, 
            icon: const Icon(Icons.folder_open)),
          IconButton(
            iconSize: 19,
            hoverColor: Colors.transparent,
            color: const Color(0xFF805306),
             tooltip: '',
            onPressed: (){
            ref.read(homeProvider.notifier).changePage(1);
            }, 
            icon: const Icon(
              Icons.settings)),
           //DOJO   const Padding(
           //     padding:  EdgeInsets.only(right: 5),
           //     child:  WindowButtons(),
           //   )
        ],
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AlertD extends StatelessWidget {   // выводим на экран слова песни
  const AlertD({required this.theme,required this.lyrics, Key? key}) : super(key: key);
final String lyrics;
final bool theme;
  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: theme ? Colors.black : Colors.white,
       scrollable: true,
      content: Text(
         style: TextStyle(color: theme ? Colors.white : Colors.black),
         lyrics)
          );
      
  }
}
/*
class Moove extends StatelessWidget { // виджет отвечающий за перемещение окна
  const Moove({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 1,
        child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                WindowTitleBarBox(child: MoveWindow()),
                Expanded(child: Container())
              ],
            )));
  }
}

final buttonColors = WindowButtonColors(
    mouseOver: Colors.transparent,
    mouseDown: Colors.transparent,
    iconNormal: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306));

    class WindowButtons extends StatelessWidget { //  Закрыть свернуть или развернуть кнопки
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: buttonColors),
      ],
    );
  }
}*/
//////////////////