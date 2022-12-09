import 'package:chat/chat.dart';
import 'package:community_portal_chat_app/data/datasource/datasource_contract.dart';
import 'package:community_portal_chat_app/models/chat.dart';
import 'package:community_portal_chat_app/models/local_message.dart';
import 'package:community_portal_chat_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

void main() {
  ChatViewModel? sut;
  MockDatasource? mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = ChatViewModel(mockDatasource!);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2022-12-09"),
    'id': '4444'
  });

  test('initial messages return empty list', () async {
    when(mockDatasource?.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut?.getMessages('123'), isEmpty);
  });

  test('returns list of messages from local storage', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource?.findMessages(chat.id))
    .thenAnswer((_) async => [localMessage]);

    final messages = await sut?.getMessages('123');
    expect(messages, isNotEmpty);
  });

  test('creates a new chat when sending first message', () async {
    when(mockDatasource?.findChat(any)).thenAnswer((_) async => null);
    await sut?.sentMessage(message);
    verify(mockDatasource?.addChat(any)).called(1);
  });

  test('add new sent message to the chat', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource?.findMessages(chat.id))
    .thenAnswer((_) async => [localMessage]);

    await sut?.getMessages(chat.id);
    await sut?.sentMessage(message);

    verifyNever(mockDatasource?.addChat(any));
    verify(mockDatasource?.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = Chat('111');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivered);
     when(mockDatasource?.findMessages(chat.id))
    .thenAnswer((_) async => [localMessage]);
    when(mockDatasource?.findChat(chat.id)).thenAnswer((_) async => chat);

    await sut?.getMessages(chat.id);
    await sut?.receivedMessage(message);

    verifyNever(mockDatasource?.addChat(any));
    verify(mockDatasource?.addMessage(any)).called(1);
  });

  test('create a new chat when message is received is not a part of this chat',
  () async {
    final chat = Chat('111');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDatasource?.findMessages(chat.id))
    .thenAnswer((_) async => [localMessage]);
    when(mockDatasource?.findChat(chat.id)).thenAnswer((_) async => null);

    await sut?.getMessages(chat.id);
    await sut?.receivedMessage(message);

    verify(mockDatasource?.addChat(any)).called(1);
    verify(mockDatasource?.addMessage(any)).called(1);
    expect(sut?.otherMessages, 1);

  });
}