import 'dart:ffi';

import 'package:smaq/bass/basswasapi.dart';
import '../bass/bass.dart';
import '../dll.dart';
import '../helper.dart';
import '../settings.dart';
class Bass{
 static var api = BassApi(Dll.api!);
static var wapi = Basswasapi(Dll.wasapi!);
 static int errorCode() => api.BASS_ErrorGetCode();
  static String myErr = 'null';
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static String getError(int s){
switch(s) { 
      case 0: {  myErr = 'BASS_OK'; } break; 
      case 1: {  myErr = 'BASS_ERROR_MEM'; } break; 
      case 2: {  myErr = 'BASS_ERROR_FILEOPEN'; } break; 
      case 3: {  myErr = 'BASS_ERROR_DRIVER'; } break; 
      case 4: {  myErr = 'BASS_ERROR_BUFLOST'; } break; 
      case 5: {  myErr = 'BASS_ERROR_HANDLE'; } break; 
      case 6: {  myErr = 'BASS_ERROR_FORMAT'; } break; 
      case 7: {  myErr = 'BASS_ERROR_POSITION'; } break; 
      case 8: {  myErr = 'BASS_ERROR_INIT'; } break; 
      case 9: {  myErr = 'BASS_ERROR_START'; } break; 
      case 10: {  myErr = 'BASS_ERROR_SSL'; } break; 
      case 14: {  myErr = 'BASS_ERROR_ALREADY'; } break; 
      case 17: {  myErr = 'BASS_ERROR_NOTAUDIO'; } break; 
      case 18: {  myErr = 'BASS_ERROR_NOCHAN'; } break; 
      case 19: {  myErr = 'BASS_ERROR_ILLTYPE'; } break; 
      case 20: {  myErr = 'BASS_ERROR_ILLPARAM'; } break; 
      case 21: {  myErr = 'BASS_ERROR_NO3D'; } break; 
      case 22: {  myErr = 'BASS_ERROR_NOEAX'; } break; 
      case 23: {  myErr = 'BASS_ERROR_DEVICE'; } break; 
      case 24: {  myErr = 'BASS_ERROR_NOPLAY'; } break; 
      case 25: {  myErr = 'BASS_ERROR_FREQ'; } break; 
      case 27: {  myErr = 'BASS_ERROR_NOTFILE'; } break; 
      case 29: {  myErr = 'BASS_ERROR_NOHW'; } break; 
      case 31: {  myErr = 'BASS_ERROR_EMPTY'; } break; 
      case 32: {  myErr = 'BASS_ERROR_NONET'; } break; 
      case 33: {  myErr = 'BASS_ERROR_CREATE'; } break; 
      case 34: {  myErr = 'BASS_ERROR_NOFX'; } break; 
      case 37: {  myErr = 'BASS_ERROR_NOTAVAIL'; } break; 
      case 38: {  myErr = 'BASS_ERROR_DECODE'; } break; 
      case 39: {  myErr = 'BASS_ERROR_DX'; } break; 
      case 40: {  myErr = 'BASS_ERROR_TIMEOUT'; } break; 
      case 41: {  myErr = 'BASS_ERROR_FILEFORM'; } break; 
      case 42: {  myErr = 'BASS_ERROR_SPEAKER'; } break; 
      case 43: {  myErr = 'BASS_ERROR_VERSION'; } break; 
      case 44: {  myErr = 'BASS_ERROR_CODEC'; } break; 
      case 45: {  myErr = 'BASS_ERROR_ENDED'; } break; 
      case 46: {  myErr = 'BASS_ERROR_BUSY'; } break; 
      case 47: {  myErr = 'BASS_ERROR_UNSTREAMABLE'; } break; 
      case -1: {  myErr = 'BASS_ERROR_UNKNOWN'; } break; 
      default: {  } break; 
   }
   return myErr;
    }
// проверка на ошибки.
static void check(int check){
  if(check == 0){
   var mystr = getError(errorCode());
saveError(mystr);
    throw Exception();
  }
}
// Чистим и освобождаем память.
static void destroy(){

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
static void init() { 
   WasapiState state;
  api.BASS_Free();
  wapi.BASS_WASAPI_Free();
   Settings.exclusive ? state = WasapiState.exclusive : state = WasapiState.normal;
  print('Init BASS');
  
  
   destroy();
   api.BASS_SetConfig(BASS_CONFIG_FLOATDSP,1);
 
 var init = api.BASS_Init(state.bassDevice, 44100, BASS_DEVICE_FREQ, nullptr, nullptr);
 try{
    check(init);
  }
  catch(_){
    // Printing error
  
          var err = 'ERROR iniBass() CODE:$myErr';
    saveError(err);
      print(err);
  }
}
}