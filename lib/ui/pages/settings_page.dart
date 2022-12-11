// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smaq/state/appbar_state.dart';
import 'package:smaq/state/cover_state.dart';
import 'package:smaq/state/settings_state.dart';
import 'package:smaq/state/slider_state.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../helper.dart';
import '../../player/player.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../settings.dart';

class SettingsPage extends ConsumerWidget{
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      debugPrint('build settings');
  final settings = ref.watch(settingsProvider);
    return  Column(children: [
      Row(children:  [

const Spacer(flex:1),
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
  Text(
      style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
    'Equalizer on/off'),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.scale(scaleY: 0.7,
                   child: Switch(
              value: settings['eq'],
              onChanged: (value) {
                ref.read(settingsProvider.notifier).enableEQ(value);
              },
              activeTrackColor: Settings.darkTheme ? Colors.white : const Color.fromARGB(255, 172, 172, 172),
              activeColor: const Color.fromARGB(255, 0, 200, 0),
              inactiveTrackColor: Settings.darkTheme ? Colors.white : null,
              inactiveThumbColor:Settings.darkTheme ? const Color.fromARGB(255, 200, 0, 0) : null,
            )
            ),
      ),
      ],),
const Spacer(flex:2),
  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
  Text(
     style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
   ' "Exclusive mode"'),
               Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.scale(scaleY: 0.7,
                   child: Switch(
            value: settings['exc'],
            onChanged: (value) {
              if(Settings.data[Settings.listCount].isNotEmpty)
              {
              ref.read(settingsProvider.notifier).changeMode(value);
              }
            },
             activeTrackColor: Settings.darkTheme ? Colors.white : const Color.fromARGB(255, 172, 172, 172),
              activeColor: const Color.fromARGB(255, 0, 200, 0),
              inactiveTrackColor: Settings.darkTheme ? Colors.white : null,
              inactiveThumbColor:Settings.darkTheme ? const Color.fromARGB(255, 200, 0, 0) : null,
          ),
                   
                   
        ),
               )
      ],),
     const Spacer(flex:2),
  Row(
              mainAxisAlignment: MainAxisAlignment.center,
             children:  [
  Text(
     style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
   ' Voxengo equalizer:'),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.scale(scaleY: 0.7,
                   child:Switch(
            value: settings['vst'],
            onChanged: (value) {
              if(Settings.data[Settings.listCount].isNotEmpty)
              {
           ref.read(settingsProvider.notifier).enableVst(value);
              }
            },
           activeTrackColor: Settings.darkTheme ? Colors.white : const Color.fromARGB(255, 172, 172, 172),
              activeColor: const Color.fromARGB(255, 0, 200, 0),
              inactiveTrackColor: Settings.darkTheme ? Colors.white : null,
              inactiveThumbColor:Settings.darkTheme ? const Color.fromARGB(255, 200, 0, 0) : null,
          ),
          )
          ),
           ],),
const Spacer(flex:1),
      ],),
        Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
  Text(
    style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
   'dark mode'),
       Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Transform.scale(scaleY: 0.7,
                   child:Switch(
            value: settings['darkmode'],
            onChanged: (value) {
              ref.read(settingsProvider.notifier).enableDarkMode(value);
              ref.read(coverProvider.notifier).enableDarkCover(value);
              ref.read(appBarProvider.notifier).enableDarkAppBar(value);
              ref.read(clockProvider.notifier).enableDarkSlider(value);
            },
           activeTrackColor: Settings.darkTheme ? Colors.white : const Color.fromARGB(255, 172, 172, 172),
              activeColor: const Color.fromARGB(255, 0, 200, 0),
              inactiveTrackColor: Settings.darkTheme ? Colors.white : null,
              inactiveThumbColor:Settings.darkTheme ? const Color.fromARGB(255, 200, 0, 0) : null,
          ),
        )
       ),
      ],),
   Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [

 for ( int i= (Settings.vstEq ? 1 : 0);i<(Settings.vstEq ? 18:Equ.dx.freq.length);i++ )
 Expanded(child:
Column(children: [
  Text(
     style:  TextStyle(color:Settings.darkTheme ? Colors.white : Colors.black),
    Settings.vstEq ? i==17 ? '' : Equ.vox.freq[i-1].toInt().toString() : Equ.dx.freq[i].toInt().toString() ),
    SfTheme(data: SfThemeData(
      sliderThemeData: SfSliderThemeData(
        thumbRadius: 0,
        activeTrackHeight: 4
      )
    ), child: 
SfSlider.vertical(
  activeColor: Colors.red,
      min:settings['vst'] ? 0.0 : -15,
      max:settings['vst'] ? 1.0 : 15,
      value:settings['vst'] ? EQ.myeq['voxVal']![i] : EQ.myeq['dxVal']![i],
      interval:settings['vst'] ? 0.025 : 0.5,
      showTicks: false,
      showLabels: false,
      enableTooltip: false,
      minorTicksPerInterval: 1,

    onChangeStart: (v){

    },
    onChangeEnd: (v){

    },
      onChanged: (dynamic value) {
       var eqVal =  Settings.vstEq ? EQ.myeq['voxVal']![i] : EQ.myeq['dxVal']![i];
      if (value > eqVal)
      {
          ref.read(settingsProvider.notifier).changeEQup(Settings.vstEq ? EQ.myeq['voxVal']![i] : EQ.myeq['dxVal']![i],i);
      }
      if (value < eqVal)
      {
          ref.read(settingsProvider.notifier).changeEQdown(Settings.vstEq ? EQ.myeq['voxVal']![i] : EQ.myeq['dxVal']![i],i);
      }
      },
    ),),
     ],),)]),
   
    
      
    ],);
  }


}