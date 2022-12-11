import 'package:flutter/material.dart';
import 'package:smaq/helper.dart';
class IncrementIntent extends Intent {
  const IncrementIntent({required this.index});

  final int index;
}
class SelectAllAction extends Action<IncrementIntent> {

  initialize(){
    
  }
  

  @override
  void invoke(IncrementIntent intent){
    saveError('TESTIM');
  }
}