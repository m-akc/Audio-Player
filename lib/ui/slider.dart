
//import 'dart:ffi';
//import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/settings.dart';
import 'package:smaq/state/appbar_state.dart';
import 'package:smaq/state/tracklist_state.dart';

import '../helper.dart';
import '../player/player.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../state/cover_state.dart';
import '../state/slider_state.dart';
/*import '../myffi.dart';
import '/helper.dart';
import '../player/f_manager.dart';
import '../player/player.dart';
import '../player/settings.dart';
import 'buttons.dart';
import 'globalstates.dart';*/

class MPSlider extends ConsumerWidget {
  const MPSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final Color buttonColor = Settings.darkTheme ? Colors.white :Colors.black;
    late String title;
    final current = ref.watch(clockProvider);
      title = Settings.data[Settings.listCount].isNotEmpty ?  "${Settings.data[Settings.listCount][Settings.songCount].artist} - ${Settings.data[Settings.listCount][Settings.songCount].title}" : '';
     if(ref.read(appBarProvider.notifier).title != title)
     {
       WidgetsBinding.instance.addPostFrameCallback((_){
try{
 ref.read(appBarProvider.notifier).changeAppBarTitle(title);
    ref.read(coverProvider.notifier).changeCover();
     ref.read(listProvider.notifier).addPlaylistCover(Settings.listCount);
     if(!Settings.songChangedbyButton)
     {
   ref.read(listProvider.notifier).changeSong(Settings.songCount);
     }
     Settings.songChangedbyButton = false;
     if(!Settings.showSearch ? Settings.data[Settings.listCount].isNotEmpty :Settings.search.isNotEmpty)
  {
    if (track(null).cue)
    {
   MP.setPosition(track(null).startTime);
    }
  }
} catch (e){
  print('post error $e');
}
   
    
});
     }
   //  print(current['slide']!);
   //  print(min());
   //  print(max());
    return SizedBox(
      height: 60,
      child: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
                0.33,
                1.0,
              ],
              colors: [
               Settings.darkTheme ? Colors.black : Colors.white,
               Settings.darkTheme ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(0, 255, 255, 255)
              ],
            )
          ),
        child:Column(children: [
Stack(children: [
  SliderTheme(
  data: SliderTheme.of(context).copyWith(
    thumbColor:   Settings.data[Settings.listCount].isNotEmpty ? Settings.darkTheme ? Colors.red :const Color.fromARGB(255, 0, 0, 0) : Colors.transparent,
    activeTrackColor:Settings.darkTheme ? Colors.red : Colors.black,
    inactiveTrackColor: Colors.transparent,
    trackHeight: 1,
    overlayShape: SliderComponentShape.noOverlay,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6, elevation: Settings.data[Settings.listCount].isNotEmpty ? 1 : 0),
  ),
  child:
Slider(
      min:min(),
      max:max(),
      value: Settings.position ? current['slide']! : Settings.pos,
      onChangeStart: (value)  {
       ref.read(clockProvider.notifier).changeSlide(value);
      MP.sliderChanged(SliderState.start, value.toInt());
            },
            onChangeEnd: (value)  {
           ref.read(clockProvider.notifier).changeSlide(value);
          MP.sliderChanged(SliderState.end, value.toInt());
            },
            onChanged: (value) async {
               ref.read(clockProvider.notifier).changeSlide(value);
            },
      ),),
 Padding(
   padding: const EdgeInsets.only(top:10),
   child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
           style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
  Settings.data[Settings.listCount].isNotEmpty ?   Duration(seconds: MP.currPosinSeconds(pos:!track(null).cue ?
   Settings.pos.toInt():(Settings.pos - MP.trackLeninBytes(track(null).startTime.toDouble())).toInt()).toInt()).formatMS(): ''),
        ),
        ],),
 ),
 Padding(
  padding: const EdgeInsets.only(top: 20),
  child:  Row(children: [
    const Spacer(flex:1),
    Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [  
                  
                   ElevatedButton(
          onHover: (value) {
           ref.read(clockProvider.notifier).changeColor(0,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: ()  { 
        ref.read(listProvider.notifier).prev();
            },
          child:    Icon(
            color: ref.read(clockProvider.notifier).hoverList[0] ? Colors.red : buttonColor,
            Icons.skip_previous),
        ),
      ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(1,value);
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
            if(Settings.data[Settings.listCount].isNotEmpty)
            {
             ref.read(listProvider.notifier).stopped();
            }
             },
           child:   Icon(
            color: ref.read(clockProvider.notifier).hoverList[1] ? Colors.red : buttonColor,
            Icons.stop),
        ),
          ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(2,value);
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
            if(Settings.data[Settings.listCount].isNotEmpty)
            {
           ref.read(listProvider.notifier).playing();
             if (track(null).cue)
    {
      if(MP.restart !=1)
      {
   MP.setPosition(track(null).startTime);
      }
    }
            }
             },
           child:   Icon(
            color: ref.read(clockProvider.notifier).hoverList[2] ? Colors.red : buttonColor,
            Icons.play_arrow),
        ),
          ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(3,value);
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
            if(Settings.data[Settings.listCount].isNotEmpty)
            {
             ref.read(listProvider.notifier).paused();
            }
             },
           child:   Icon(
            color: ref.read(clockProvider.notifier).hoverList[3] ? Colors.red : buttonColor,
            Icons.pause),
        ),
               ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(4,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: ()  { 
         ref.read(listProvider.notifier).next();
            },
          child:  Icon(
           color: ref.read(clockProvider.notifier).hoverList[4] ? Colors.red : buttonColor,
            Icons.skip_next),
        ),
        ],),
    const Spacer(flex: 1),
     ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(5,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: ()  { 
            ref.read(clockProvider.notifier).enableLoop();
            },
          child:   Icon(
           color: ref.read(clockProvider.notifier).hoverList[5] ? Colors.red : Settings.options == PlayerOptions.loop ? Colors.orange : buttonColor,
          Icons.repeat),
        ),
     ElevatedButton(
          onHover: (value) {
             ref.read(clockProvider.notifier).changeColor(6,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: ()  { 
        ref.read(clockProvider.notifier).enableShuffle();
            },
          child:   Icon(
             color: ref.read(clockProvider.notifier).hoverList[6] ? Colors.red : Settings.options == PlayerOptions.shuffle ? Colors.orange : buttonColor,
           Icons.shuffle),
        ),
    Row(children: [
        ElevatedButton(
          onHover: (value) {
            ref.read(clockProvider.notifier).changeColor(7,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: ()  { 
          
            ref.read(clockProvider.notifier).soundOff();
            ref.read(clockProvider.notifier).changeVol(current['vol']);
            },
          child:  Icon(
             color: ref.read(clockProvider.notifier).hoverList[7] ? Colors.red : buttonColor,
           Settings.mute ? Icons.volume_off : Icons.volume_up),
        ),
     SfTheme(data: SfThemeData(
      sliderThemeData: SfSliderThemeData(
        overlayRadius: 7,
        thumbRadius: 0,
        activeTrackHeight: 4
      ),
    ), child: 
Padding(
  padding: const EdgeInsets.only(right: 15),
  child:   SfSlider(
    activeColor:Settings.darkTheme ? Colors.red : Colors.black,
        min:0.0,
        max:1.0,
        value: current['vol'],
        interval: 0.1,
        showTicks: false,
        showLabels: false,
        enableTooltip: false,
      onChangeStart: (v){
  ref.read(clockProvider.notifier).changeVol(v);
      },
  
      onChangeEnd: (v){
   ref.read(clockProvider.notifier).changeVol(v);
      },
  
        onChanged: (dynamic value) {
   ref.read(clockProvider.notifier).changeVol(value);
        },
      ),
),
),
]
),
  ]),
),
],),
    ],)));
    
  }
}