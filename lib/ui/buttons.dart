
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/settings.dart';

class Buttons extends ConsumerWidget{
   const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   //  ref.watch(colorProvider);
   // ref.watch(sProvider);
   // final Color buttonColor = Settings.darkTheme ? Colors.white :Colors.black;
    return Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [  
                  
                   ElevatedButton(
          onHover: (value) {
       //    ref.read(colorProvider.notifier).changeColor(0,value);
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
            
            },
          child:    Icon(
            color: Colors.red,
            Icons.skip_previous),
        ),
      ElevatedButton(
          onHover: (value) {
        //     ref.read(colorProvider.notifier).changeColor(1,value);
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
          //   MP.changeState(PlayerState.stopped);
          //   MP.nextsong = false;
             },
           child:   Icon(
            color: Colors.red,
            Icons.stop),
        ),
      /*  ElevatedButton(
          onHover: (value) {
             ref.read(colorProvider.notifier).changeColor(2,value);
          },
          style:  ElevatedButton.styleFrom(
          elevation:  Settings.darkTheme ? 0 : null,
            onSurface: Settings.darkTheme ?Colors.transparent : null,
            onPrimary: Settings.darkTheme ? Colors.transparent :null,
            surfaceTintColor:Settings.darkTheme ? Colors.transparent : null,
           primary: Colors.transparent,
           shadowColor: Colors.transparent,
          ),
          onPressed: () {
         //  print( MP.wapi.BASS_WASAPI_GetVolume(BASS_WASAPI_CURVE_WINDOWS));
       
           MP.changeState(PlayerState.playing);
           if(!MP.nextsong)
           {
              MP.nextsong = true;
           ref.refresh(clockProvider);
          
           }
        },
        
          child:  Icon(
            color: Colors.red,
            Icons.play_arrow),
        ),
           ElevatedButton(
          onHover: (value) {
             ref.read(colorProvider.notifier).changeColor(3,value);
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
             MP.changeState(PlayerState.paused);
                 MP.nextsong = false;
             },
           child:   Icon(
           color: ref.read(colorProvider.notifier).hoverList[3] ? Colors.red : buttonColor,
            Icons.pause),
        ),
      */
               ElevatedButton(
          onHover: (value) {
        //     ref.read(colorProvider.notifier).changeColor(2,value);
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
        
            },
          child:  Icon(
         color: Colors.red,
            Icons.skip_next),
        ),
        ],);
    
  }
}