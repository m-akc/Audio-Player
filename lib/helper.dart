import 'dart:io';

import 'package:flutter/material.dart';

import 'Model/track.dart';
import 'bass/bass.dart';
import 'dll.dart';
import 'player/player.dart';
import 'settings.dart';
import 'ui/pages/home.dart';
import 'ui/pages/settings_page.dart';
//////// Парсим строку и превращаем ее в Duration
Duration parseDuration(String s) {
  int minutes = 0;
  int seconds = 0;
  List<String> parts = s.split(':');
    minutes = int.parse(parts[0]);
    seconds = int.parse(parts[1]);
  return Duration(minutes: minutes, seconds: seconds);
}

extension DurationExtension on Duration {
  /// Форматируем кол-во секунд в нормальный вид. 100 секунд = 1:40
  /// 
  String formatMS() {
    // ignore: unnecessary_this
    int currentSecond = this.inSeconds;

    int minutes = (currentSecond / 60).floor();
    int seconds = currentSecond - (minutes * 60);

    String sMinutes = (minutes > 0) ? "$minutes:" : "0:";
    String sSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";

    return "$sMinutes$sSeconds";
  }
}
enum WasapiState{
  exclusive(0,
      BASS_SAMPLE_FLOAT | BASS_ASYNCFILE | BASS_UNICODE | BASS_STREAM_DECODE | BASS_STREAM_PRESCAN,
      BASS_UNICODE | BASS_SAMPLE_FLOAT | BASS_STREAM_DECODE),
  normal(-1,
      BASS_SAMPLE_FLOAT | BASS_ASYNCFILE | BASS_UNICODE | BASS_STREAM_PRESCAN,
      BASS_UNICODE | BASS_SAMPLE_FLOAT);

  final int bassDevice;
  final int flags;
  final int radioflags;
  const WasapiState(this.bassDevice, this.flags, this.radioflags);
}

enum PlayerFx {
  fxDown,
  fxUp,
}
enum PlayerState{
  playing,
  stopped,
  paused,
  next,
  previous
}
enum SliderState{
  start,
  end,
}
enum PlayerOptions{
  loop,
  shuffle,
  standart
}
enum Equ{
  vox([20.0,31.7,50.2,79.6,126,200,317,502,796,1260,2000,3170,5020,7960,12600,20000],0.025,0.0,1.0), // 1-16
  dx([90,140,250,500,1000,2000,4000,8500,11000,14500],0.5,-15.0,15.0); //0-9

final List<double> freq;
final double valueChange;
final double min;
final double max;
const Equ(this.freq, this.valueChange, this.min, this.max);
}
////////// сюда пишем логи
 void saveError(String mystr){
//var exeP = exePath.replaceAll(RegExp(r'\\'), '/');
File file = File('${runPath}errorlog.txt');
file.writeAsStringSync('$mystr\n',mode: FileMode.append);
//file.writeAsStringSync('\n',mode: FileMode.append);
}
////////// Функция для доступа к текущему треку.
 Track track(int? songindex){
  if(Settings.data[Settings.listCount].isNotEmpty)
  {
  return Settings.data[Settings.listCount][songindex ?? Settings.songCount];
  }

  return Track.custom(path: '', startTime: 0, endTime: 0, cue: false);
}
/////// Лист, который содержит список возможных страниц приложения
List<Widget> wList = [
const MainPage(),
const SettingsPage()
];
/////// Считаем минимальное значение на слайдере трека.
double min(){
  return Settings.data[Settings.listCount].isNotEmpty ? !track(null).cue ? 0 : MP.trackLeninBytes(track(null).startTime.toDouble()).toDouble() : 0;
}
/////// Считаем Максимальное значение на слайдере трека
double max(){
  return Settings.data[Settings.listCount].isNotEmpty ? 
  !track(null).cue ? 
  MP.trackLen().toDouble():
  MP.trackLeninBytes(track(null).endTime == 0 ? MP.trackLenInSeconds():track(null).endTime.toDouble()).toDouble():
  MP.trackLen().toDouble();
}