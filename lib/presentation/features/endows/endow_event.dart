import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class EndowEvent extends Equatable {
  @override
  List<Object> get props => [];
}
@immutable
class EndowLoadEvent extends EndowEvent {
  @override
  String toString() => 'Endow is Loaded';
}