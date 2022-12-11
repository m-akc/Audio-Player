
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper.dart';
import '../../settings.dart';
import '../../state/cover_state.dart';
import '../../state/tracklist_state.dart';
import '../appbar.dart';
import '../cardmusic.dart';
import '../slider.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    print('main widget build');
  final cover =  ref.watch(coverProvider);
    return Stack(
      children: [
     //DOJO  WindowTitleBarBox(child: MoveWindow()),
       Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:Settings.data[Settings.listCount].isEmpty ? const AssetImage('assets/12.jpg') as ImageProvider: NetworkImage(ref.read(coverProvider.notifier).cover), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Theme(
  data: ThemeData().copyWith(
   // backgroundColor: Colors.transparent,
    dividerColor: Colors.transparent,
  ),
  child:Scaffold(
       backgroundColor: cover['cover'] != '' ? Settings.darkTheme ?const Color.fromARGB(230, 0, 0, 0): const Color.fromARGB(200, 255, 255, 255) :
     Settings.darkTheme ?const Color.fromARGB(255, 0, 0, 0): const Color.fromARGB(255, 255, 255, 255),
    extendBody: true,
      appBar: const MPappBar(),
      body: Consumer(builder: (context, ref, _) {
     final pageCount = ref.watch(homeProvider);
        return wList[pageCount];
        }),
    bottomNavigationBar: const MPSlider(),
    ),
    ),
    ]
    );
  }
}



class MainPage extends ConsumerWidget{
   const MainPage({Key? key}) : super(key: key);
 final o = Colors.orange;
 final w = Colors.white;
 final b = Colors.black;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final Color buttonColor = Settings.darkTheme ? Colors.white :Colors.black;
    print('main page build');
   // double height = MediaQuery.of(context).size.height;
    final my =  ref.watch(listProvider);
   return
           Padding(
             padding: const EdgeInsets.only(bottom: 60),
             child: Row(children:[Expanded(
              child:ListView.builder(
                controller: ScrollController(),
          addAutomaticKeepAlives: false,
   addRepaintBoundaries: false,
        //  physics: const BouncingScrollPhysics(),
          itemCount:  Settings.data[Settings.listCount].length,
          itemBuilder: (context, index) {
  return Settings.data[Settings.listCount].isNotEmpty ? Dismissible(
    key: Key(track(index).toString()),
    onDismissed: (direction) {
      
  if (direction == DismissDirection.startToEnd) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Что-то делаем 1")));
            } else if (direction == DismissDirection.endToStart) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Что-то делаем 2")));
            }
    },
    child: GestureDetector(
      onDoubleTap: (){
           if(Settings.data[Settings.listCount].isNotEmpty)
            {
           ref.read(listProvider.notifier).changeSong(index);
            }
      },
      onTap: (){
//ref.read(listProvider.notifier).select(index);
      },
      onSecondaryTap: (){
        print('click $index');
      //  ref.read(listProvider.notifier).rightClick(index, track(index).selected);
      },
      child:CardMusic(
                       onPressedEditSong: (){
                        ref.read(listProvider.notifier).editSong(index, !track(index).edit);
                       },
                        onPressedLikedSong: (){},
                        data: CardMusicData(
                          index: index,
                          edit: track(index).edit,  //Settings.data[Settings.listCount][index].edit,
                          selected: track(index).selected,   //Settings.data[Settings.listCount][index].selected,
                          title:  track(index).title!, //Settings.data[Settings.listCount][index].title ?? 'Нет Информации',
                          subtitle: track(index).artist!,//  Settings.data[Settings.listCount][index].artist ?? 'Нет Информации',
                          album: track(index).album!,  //Settings.data[Settings.listCount][index].album ?? 'Нет Информации',
                          duration: Duration(seconds:  track(index).len ?? 0),
                        ),
                      )
                      )
                      ):const Text('');
                      }
                      ),
                      ),
                     SizedBox(width: 50,child: ListView.builder(
          addAutomaticKeepAlives: false,
   addRepaintBoundaries: false,
          physics: const BouncingScrollPhysics(),
          itemCount:  Settings.data.length+1,
          itemBuilder: (context, index) {
        
            if(index == 0)
            {
              if (Settings.showSearch) {
                return ElevatedButton(
          onHover: (value) {
        //     ref.read(clockProvider.notifier).changeColor(1,value);
          },
          style:  ElevatedButton.styleFrom(
           elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: (){
       ref.read(listProvider.notifier).changePlaylist(index);
             },
           child:   Icon(
            size: 30,
            color: buttonColor,
            Icons.search),
        );
              }else {
                return const SizedBox(
          height: 0,
          width: 0,
        );
                }
            }
  return   index == Settings.data.length ? 
   GestureDetector(
    child: Container(
      width: 40,
      height: 40,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: Settings.darkTheme ? Svg(color:w,'assets/paddw.svg'): const Svg('assets/padd.svg'), // <-- BACKGROUND IMAGE
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
onTap: ()
{
  Settings.playlistPic.add(false);
    Settings.data.add([]);
    Settings.listOfCovers.add('');
    Settings.selectedList.add(false);
     ref.read(listProvider.notifier).stopped();
  ref.read(listProvider.notifier).changePlaylist(Settings.data.length-1);
},
  ) : 
  GestureDetector(
    child: Container(
      margin: const EdgeInsets.all(3.0),
        width: 40,
      height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Settings.selectedList[index] && Settings.data[index].isNotEmpty ? o : Settings.playlistPic[index] ? buttonColor :Colors.transparent,width: 3),
            image: DecorationImage(
              image:Settings.data[index].isEmpty ? Settings.selectedList[index] ? Svg(color:o,'assets/plistorange.svg'):
              Settings.darkTheme ? Svg(color:w,'assets/plistwhite.svg'):const Svg('assets/plistblack.svg') :
              Settings.playlistPic[index] ? NetworkImage(my['playlist'][index] as String) as ImageProvider : const Svg('assets/plistblack.svg'), // <-- BACKGROUND IMAGE
              fit: BoxFit.fill,
            ),
          ),
        ),
onTap: ()
{
   ref.read(listProvider.notifier).stopped();
  ref.read(listProvider.notifier).changePlaylist(index);
},
onSecondaryTap: (){
  print('click!');
},
  );
  
  
  
  
  
  /*
   ElevatedButton(
          onHover: (value) {
        //     ref.read(clockProvider.notifier).changeColor(1,value);
          },
          style:  ElevatedButton.styleFrom(
           elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: (){
              Settings.data.add([]);
            ref.read(listProvider.notifier).changePlaylist(index);
          //  print(index);
             },
           child:   Icon(
            size: 30,
            color: buttonColor,
            Icons.playlist_add),
        )
  :  ElevatedButton(
          onHover: (value) {
        //     ref.read(clockProvider.notifier).changeColor(1,value);
          },
          style:  ElevatedButton.styleFrom(
           elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: (){
       ref.read(listProvider.notifier).changePlaylist(index);
             },
           child:   Icon(
            size: 30,
            color: buttonColor,
            Icons.featured_play_list_sharp),
        );*/
  })
  )
             ])
           );
  }
}

