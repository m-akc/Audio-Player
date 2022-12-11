
import 'dart:ffi';
import 'dart:io';
//import 'package:ffi/ffi.dart';
import 'dart:io' as io;

import 'package:smaq/helper.dart';

String _platformPath(String name, String path) {
  if (io.Platform.isLinux || io.Platform.isAndroid || io.Platform.isFuchsia)
   { return "${path}lib$name.so";}
  if (io.Platform.isMacOS) return "${path}lib$name.dylib";
  if (io.Platform.isWindows) return "$path$name.dll";
  throw Exception("Platform not implemented");
}

DynamicLibrary dlopenPlatformSpecific(String name, {String path = ""}) {
  String fullPath = _platformPath(name, path);
  saveError('$fullPath ${DateTime.now()}');
  return DynamicLibrary.open(fullPath);
}
const String dirPath =  '\\data\\flutter_assets\\dll\\';
final String exePath = File(Platform.resolvedExecutable).parent.path;
//final String exePath = File(Platform.resolvedExecutable).uri.toFilePath(windows:true);
String runPath = '$exePath\\';
//final String dllPathh = exePath + dirPath;
// ищем наше окно программы
 //Pointer<HWND__> hwnd_ = Pointer.fromAddress(findWindowA('FLUTTER_RUNNER_WIN32_WINDOW'.toNativeUtf8(), nullptr));
 //final _user32 = DynamicLibrary.open('user32.dll');

// final findWindowA = _user32.lookupFunction<
   //   Int32 Function(Pointer<Utf8> _lpClassName, Pointer<Utf8> _lpWindowName),
   //   int Function(Pointer<Utf8> _lpClassName,
  //        Pointer<Utf8> _lpWindowName)>('FindWindowA');
// Подключаем библиотеки
class Dll{
 static DynamicLibrary? api;
 static DynamicLibrary? wasapi;
 static DynamicLibrary? vstapi;
 static DynamicLibrary? hlsapi;
static DynamicLibrary? encmp3api;
 static DynamicLibrary? encapi;
 static DynamicLibrary? apeapi;
 static DynamicLibrary? tagapi;
 static DynamicLibrary? opusapi;
 static DynamicLibrary? wvapi;
 static DynamicLibrary? webmapi;
 static String? dllPath;
  static void initDLL(){
   //  var exeP = exePath.replaceAll(RegExp(r'\\'), '/');
      dllPath = exePath + dirPath;
try {
     
tagapi = dlopenPlatformSpecific('libtag_c',path: runPath);
api = dlopenPlatformSpecific('bass',path: runPath);
wasapi = dlopenPlatformSpecific('basswasapi',path: runPath);
vstapi = dlopenPlatformSpecific('bass_vst',path: runPath);
hlsapi = dlopenPlatformSpecific('basshls',path: runPath);
encmp3api = dlopenPlatformSpecific('bassenc_mp3',path: runPath);
encapi = dlopenPlatformSpecific('bassenc',path: runPath);
apeapi = dlopenPlatformSpecific('bassape',path: runPath);
opusapi = dlopenPlatformSpecific('bassopus',path: runPath);
wvapi = dlopenPlatformSpecific('basswv',path: runPath);
webmapi = dlopenPlatformSpecific('basswebm',path: runPath);
} catch (e) {
      try {
        
   tagapi = dlopenPlatformSpecific('libtag_c');
   api = dlopenPlatformSpecific('bass');
wasapi = dlopenPlatformSpecific('basswasapi');
 vstapi = dlopenPlatformSpecific('bass_vst');
 hlsapi = dlopenPlatformSpecific('basshls');
 encmp3api = dlopenPlatformSpecific('bassenc_mp3');
 encapi = dlopenPlatformSpecific('bassenc');
 apeapi = dlopenPlatformSpecific('bassape');
 opusapi = dlopenPlatformSpecific('bassopus');
 wvapi = dlopenPlatformSpecific('basswv');
 webmapi = dlopenPlatformSpecific('basswebm');
      } catch (e) {
         saveError('error $e');
      }
    }
  }
}