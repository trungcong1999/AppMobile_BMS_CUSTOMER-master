 import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
 @immutable
abstract class EndowState extends Equatable {
  @override
  List<Object> get props => [];
}
@immutable
class EndowInitialState extends EndowState {
  @override
  String toString() => 'EndowInitialState';
}