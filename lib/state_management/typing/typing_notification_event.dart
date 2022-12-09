
part of 'typing_notification_bloc.dart';

abstract class TypingNotificationEvent extends Equatable {
  const TypingNotificationEvent();
  factory TypingNotificationEvent.onSubscribed(User? user, {List<String>? usersWithChat}) => Subscribed(user!, usersWithChat: usersWithChat!);
  factory TypingNotificationEvent.onReceiptEvent(TypingEvent event) => TypingNotifiactionSent(event);

  @override
  List<Object?> get props => [];
}

class Subscribed extends TypingNotificationEvent {
  final User user;
  final List<String>? usersWithChat;
  const Subscribed(this.user, {this.usersWithChat});

  @override
  List<Object?> get props => [user, usersWithChat];
}

class NotSubscribed extends TypingNotificationEvent {}

class TypingNotifiactionSent extends TypingNotificationEvent {
  final TypingEvent event;
  const TypingNotifiactionSent(this.event);

  @override
  List<Object?> get props => [event];
}

class _TypingNotificationReceived extends TypingNotificationEvent {
  const _TypingNotificationReceived(this.typingEvent);

  final TypingEvent typingEvent;

  @override
  List<Object?> get props => [typingEvent];
}