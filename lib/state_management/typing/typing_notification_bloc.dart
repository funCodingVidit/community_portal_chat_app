import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc extends Bloc<TypingNotificationEvent, TypingNotificationState> {

  final ITypingNotification _typingNotificationService;
  StreamSubscription? _subscription;

  TypingNotificationBloc(this._typingNotificationService): super(TypingNotificationState.initial()) {
    on<TypingNotificationEvent>((typingEvent, emit) async {
      if (typingEvent is Subscribed) {
        if (typingEvent.usersWithChat == null) {
          add(NotSubscribed());
          return;
      }
      await _subscription?.cancel();
      _subscription = _typingNotificationService.subscribe(typingEvent.user, typingEvent.usersWithChat!).listen((typingEvent) =>
        add(_TypingNotificationReceived(typingEvent)));
    }

    if (typingEvent is _TypingNotificationReceived) {
      emit(TypingNotificationState.received(typingEvent.typingEvent));
    }
    if (typingEvent is TypingNotifiactionSent) {
      await _typingNotificationService.send(event: typingEvent.event);
      emit(TypingNotificationState.sent());
    }

    if (typingEvent is NotSubscribed) {
      emit(TypingNotificationState.initial());
    }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingNotificationService.dispose();
    return super.close();
  }
}