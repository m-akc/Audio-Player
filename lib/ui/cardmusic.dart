

import 'package:flutter/material.dart';

import '../helper.dart';
import '../settings.dart';

class CardMusicData {
  final String title;
  final String subtitle;
  final String album;
  final Duration duration;
  final bool selected;
  final bool edit;
  final int index;

  CardMusicData(
      {
      required this.title,
      required this.subtitle,
      required this.album,
      required this.duration,
      required this.selected,
      required this.edit,
      required this.index,
      });
}

class CardMusic extends StatelessWidget {
  const CardMusic(
      {required this.data,
      required this.onPressedLikedSong,
      required this.onPressedEditSong,
      Key? key})
      :size = Size.zero,
        super(key: key);

  final CardMusicData data;
  final Function()? onPressedLikedSong;
   final Function()? onPressedEditSong;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return _Normal(
            data: data,
            onPressedEditSong: onPressedEditSong ?? () {},
            onPressedLikedSong: onPressedLikedSong ?? () {},
          );
        
  }
}

class _Normal extends StatelessWidget {
  const _Normal(
      {required this.data,
      required this.onPressedLikedSong,
      required this.onPressedEditSong,
      Key? key})
      : super(key: key);

  final CardMusicData data;
  final Function() onPressedLikedSong;
   final Function() onPressedEditSong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
            
          /* Row(
                      children: [
                        IconButton(
                           color: Settings.darkTheme ? Colors.white :Colors.black,
                          iconSize: 40,
                          icon: Icon((!data.isPlaying)
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded),
                          onPressed: () => onPressedPlayOrPause(),
                        ),
                     const   SizedBox(width: 30),
                      ],
                    ),*/
             const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   !data.edit ? Text(
                      data.title,
                      style:
                   TextStyle(color:data.selected ? Colors.red : Settings.darkTheme ? Colors.white :Colors.black,     
                        fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ) : SizedBox(
          width: 150,
          height: 20,
          child:TextField(
            style: TextStyle(color: Settings.darkTheme ? Colors.white : Colors.black ),
          decoration: InputDecoration(  
    border: InputBorder.none,  
    hintText: 'Edit: Song',
     hintStyle: TextStyle(color: Settings.darkTheme ? Colors.white70 : Colors.black87),
  ),  
          autofocus: true,
                    onSubmitted: (value){
                     track(data.index).editSongName(value);
                    track(data.index).title = value;
                    },

                    )),
                  const  SizedBox(height: 5),
                     !data.edit ? Text(
                      data.subtitle,
                      style:  TextStyle(color:data.selected ? Colors.redAccent : Settings.darkTheme ? Colors.white54 :Colors.black45,  fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ) :     
    SizedBox(
          width: 150,
          height: 20,
          child:TextField(
               style: TextStyle(color: Settings.darkTheme ? Colors.white : Colors.black ),
          decoration: InputDecoration(  
    border: InputBorder.none,  
   // labelText: 'Song',  
    hintText: 'Edit: Artist',
     hintStyle: TextStyle(color: Settings.darkTheme ? Colors.white70 : Colors.black87),
  ),  
          autofocus: true,
                    onSubmitted: (value){
        track(data.index).editArtist(value);            //Settings.data[Settings.listCount][data.index].editArtist(value);
        track(data.index).artist = value;            //Settings.data[Settings.listCount][data.index].artist = value;
                    },

                    )),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                color: Settings.darkTheme ? Colors.white :Colors.black,
                icon:  Icon(!data.edit ? Icons.edit : Icons.arrow_back),
                onPressed: () => onPressedEditSong(),
                tooltip: "Edit",
              ),
              const  SizedBox(width: 20),
               !data.edit ? Text(
                 style:
               TextStyle(color:data.selected ? Colors.red : Settings.darkTheme ? Colors.white :Colors.black,fontWeight: FontWeight.bold),
                data.album) : SizedBox(
          width: 150,
          height: 20,
          child:TextField(
               style: TextStyle(color: Settings.darkTheme ? Colors.white : Colors.black ),
          decoration: InputDecoration(  
            isDense: true,
            contentPadding: const EdgeInsets.all(0),
    border: InputBorder.none,  
   // labelText: 'Song',  
    hintText: 'Edit: Album',
    hintStyle: TextStyle(color: Settings.darkTheme ? Colors.white70 : Colors.black87),  
  ),  
          autofocus: true,
                    onSubmitted: (value){
                     track(data.index).editAlbum(value);
                    track(data.index).album = value;
                    },

                    )),
            const  SizedBox(width: 20),
             Text(
                style: TextStyle(color:data.selected ? Colors.red : Settings.darkTheme ? Colors.white :Colors.black, fontWeight: FontWeight.bold),
               data.duration.formatMS()),
             const SizedBox(width: 20),
              IconButton(
                 color: Settings.darkTheme ? Colors.white :Colors.black,
                icon: const Icon(Icons.favorite),
                onPressed: () => onPressedLikedSong(),
                tooltip: "liked",
              )
            ],
          ),
        ),
      ),
    );
  }
}
/////////////////////