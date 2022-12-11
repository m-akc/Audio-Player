// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: non_constant_identifier_names, camel_case_types, constant_identifier_names

import 'dart:ffi' as ffi;

/// Bindings to `bassopus.h`.
class Opus {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  Opus(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  Opus.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int BASS_OPUS_StreamCreateFile(
    int mem,
    ffi.Pointer<ffi.Void> file,
    int offset,
    int length,
    int flags,
  ) {
    return _BASS_OPUS_StreamCreateFile(
      mem,
      file,
      offset,
      length,
      flags,
    );
  }

  late final _BASS_OPUS_StreamCreateFilePtr = _lookup<
      ffi.NativeFunction<
          HSTREAM Function(BOOL, ffi.Pointer<ffi.Void>, QWORD, QWORD,
              DWORD)>>('BASS_OPUS_StreamCreateFile');
  late final _BASS_OPUS_StreamCreateFile = _BASS_OPUS_StreamCreateFilePtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Void>, int, int, int)>(
          isLeaf: true);

  int BASS_OPUS_StreamCreateURL(
    ffi.Pointer<ffi.Int8> url,
    int offset,
    int flags,
    ffi.Pointer<
            ffi.NativeFunction<
                ffi.Void Function(
                    ffi.Pointer<ffi.Void>, DWORD, ffi.Pointer<ffi.Void>)>>
        proc,
    ffi.Pointer<ffi.Void> user,
  ) {
    return _BASS_OPUS_StreamCreateURL(
      url,
      offset,
      flags,
      proc,
      user,
    );
  }

  late final _BASS_OPUS_StreamCreateURLPtr = _lookup<
      ffi.NativeFunction<
          HSTREAM Function(
              ffi.Pointer<ffi.Int8>,
              DWORD,
              DWORD,
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Void Function(ffi.Pointer<ffi.Void>, DWORD,
                          ffi.Pointer<ffi.Void>)>>,
              ffi.Pointer<ffi.Void>)>>('BASS_OPUS_StreamCreateURL');
  late final _BASS_OPUS_StreamCreateURL =
      _BASS_OPUS_StreamCreateURLPtr.asFunction<
          int Function(
              ffi.Pointer<ffi.Int8>,
              int,
              int,
              ffi.Pointer<
                  ffi.NativeFunction<
                      ffi.Void Function(ffi.Pointer<ffi.Void>, DWORD,
                          ffi.Pointer<ffi.Void>)>>,
              ffi.Pointer<ffi.Void>)>(isLeaf: true);

  int BASS_OPUS_StreamCreateFileUser(
    int system,
    int flags,
    ffi.Pointer<BASS_FILEPROCS> procs,
    ffi.Pointer<ffi.Void> user,
  ) {
    return _BASS_OPUS_StreamCreateFileUser(
      system,
      flags,
      procs,
      user,
    );
  }

  late final _BASS_OPUS_StreamCreateFileUserPtr = _lookup<
      ffi.NativeFunction<
          HSTREAM Function(DWORD, DWORD, ffi.Pointer<BASS_FILEPROCS>,
              ffi.Pointer<ffi.Void>)>>('BASS_OPUS_StreamCreateFileUser');
  late final _BASS_OPUS_StreamCreateFileUser =
      _BASS_OPUS_StreamCreateFileUserPtr.asFunction<
          int Function(int, int, ffi.Pointer<BASS_FILEPROCS>,
              ffi.Pointer<ffi.Void>)>(isLeaf: true);
}

typedef HSTREAM = DWORD;
typedef DWORD = ffi.Uint64;
typedef BOOL = ffi.Int32;
typedef QWORD = ffi.Uint64;

class BASS_FILEPROCS extends ffi.Struct {
  external ffi
          .Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>
      close;

  external ffi
          .Pointer<ffi.NativeFunction<QWORD Function(ffi.Pointer<ffi.Void>)>>
      length;

  external ffi.Pointer<
      ffi.NativeFunction<
          DWORD Function(
              ffi.Pointer<ffi.Void>, DWORD, ffi.Pointer<ffi.Void>)>> read;

  external ffi.Pointer<
      ffi.NativeFunction<BOOL Function(QWORD, ffi.Pointer<ffi.Void>)>> seek;
}

const int BASS_CTYPE_STREAM_OPUS = 70144;

const int BASS_ATTRIB_OPUS_ORIGFREQ = 77824;

const int BASS_ATTRIB_OPUS_GAIN = 77825;