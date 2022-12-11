part of bass_audio;

class EQ{
 static Map<String,List<double>> myeq = 
  {'dxVal':[0,0,0,0,0,0,0,0,0,0],
  'voxVal':[1,0.7,0.7,0.650,0.6,0.575,0.5,0.4,0.3,0.3,0.4,0.425,0.5,0.6,0.650,0.675,0.675,0.5], 'fx': []};
  static  var p = calloc<BASS_DX8_PARAMEQ>();
  
static void updateFX(int i,PlayerFx fx) {// функция для ручного изменения параметров эквалайзера.
late String val;
Equ state;
 Settings.vstEq ? state=Equ.vox : state=Equ.dx;
state == Equ.vox ? val = 'voxVal' : val = 'dxVal';
	switch(fx)
  {
    case PlayerFx.fxDown: 
    { myeq[val]![i] <=state.min ? myeq[val]![i]=myeq[val]![i] : myeq[val]![i]-=state.valueChange;
     }
    break;
    case PlayerFx.fxUp: 
    {myeq[val]![i] >=state.max ? myeq[val]![i]=myeq[val]![i] : myeq[val]![i]+=state.valueChange;
    }
    break;
  }
  if ( Settings.isFX && state == Equ.vox)
  {
   MP.vst.BASS_VST_SetParam(MP.dsp, i, myeq[val]![i]);
   print('updated voxFX');
  }
   if (Settings.isFX && state == Equ.dx)
  {
  	Bass.api.BASS_FXGetParameters(myeq['fx']![i].toInt(), p.cast());
		p.ref.fGain = myeq[val]![i];
		Bass.api.BASS_FXSetParameters(myeq['fx']![i].toInt(), p.cast());
    print('updated dxFX');
  }
}

static void initFX(bool fx) { //инициализация эффектов
 //bassApi.BASS_ChannelSetAttribute(basshandle, BASS_ATTRIB_VOL, 1);
late String val;
Equ state;
Settings.vstEq ? state=Equ.vox : state=Equ.dx;
state == Equ.vox ? val = 'voxVal' : val = 'dxVal';

if(state == Equ.vox)
{
myeq[val]![0] = fx ? 0 : 1;
MP.vst.BASS_VST_SetParam(MP.dsp, 0, myeq[val]![0]);
if (fx)
{
 for (int i=1;i<18;i++)
 {
 MP.vst.BASS_VST_SetParam(MP.dsp, i, myeq[val]![i]);
 }
}
}

if(state == Equ.dx)
{
if (fx)
{
 myeq['fx']!.clear();
       for(int i=0;i<state.freq.length;i++)
       {
 myeq['fx']!.add(Bass.api.BASS_ChannelSetFX(MP.basshandle, BASS_FX_DX8_PARAMEQ, 0).toDouble());
 Bass.api.BASS_FXGetParameters(myeq['fx']![i].toInt(), p.cast());
  p.ref.fGain = myeq[val]![i];
  p.ref.fCenter = state.freq[i];
  p.ref.fBandwidth = 4.8;
  Bass.api.BASS_FXSetParameters(myeq['fx']![i].toInt(), p.cast());
       }
}
else
{
  if(myeq['fx']!.isNotEmpty)
  {
 for(int i=0;i<state.freq.length;i++)
       {
 Bass.api.BASS_ChannelRemoveFX(MP.basshandle,myeq['fx']![i].toInt());
 Bass.api.BASS_FXReset(myeq['fx']![i].toInt());
 }
  }
}
}
       fx ? print('FX online') : print('FX Offline');
}

}