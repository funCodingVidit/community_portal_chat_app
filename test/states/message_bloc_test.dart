import 'package:chat/chat.dart';
import 'package:community_portal_chat_app/state_management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


class FakeMessageService extends Mock implements IMessageService {}

void main() {
  MessageBloc? sut;
  IMessageService? messageService;
  User? user;

  setUp(() {
    messageService = FakeMessageService();
    user = User(
      username: 'test',
      photoUrl: '',
      active: true,
      lastseen: DateTime.now()
    );
    sut = MessageBloc(messageService!);
  });

  tearDown(() => sut?.close());

  test('should emit only initial without subscriptions', () {
    expect(sut?.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () {
    final message = Message(
      from: '123',
      to: '456',
      timestamp: DateTime.now(),
      contents: 'test message',
    );

    when(messageService?.send(message)).thenAnswer((_) async => true);
    sut?.add(MessageEvent.onMessageEvent(message));
    expectLater(sut?.stream, emits(MessageState.sent(message)));
  });

  test('should emit messages received from the service', () {
    final message = Message(
      from: '123',
      to: '456',
      timestamp: DateTime.now(),
      contents: 'test message',
    );

    when(messageService?.messages(activeUser: anyNamed('activeUser')))
    .thenAnswer((_) => Stream.fromIterable([message]));

    sut?.add(MessageEvent.onSubscribed(user));
    expectLater(sut?.stream, emitsInOrder([MessageReceivedSuccess(message)]));
  });
}