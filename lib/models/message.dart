import 'package:flutter/foundation.dart';
import 'package:fl_clash/enum/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/message.freezed.dart';

@freezed
abstract class CommonMessage with _$CommonMessage {
  const factory CommonMessage({
    required String id,
    required String text,
    @Default(MessageLevel.info) MessageLevel level,
    @Default(Duration(seconds: 3)) Duration duration,
    MessageActionState? actionState,
  }) = _CommonMessage;
}

@freezed
abstract class MessageActionState with _$MessageActionState {
  const factory MessageActionState({
    required String actionText,
    required VoidCallback action,
  }) = _MessageActionState;
}
