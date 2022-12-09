import 'package:chat/chat.dart';
import 'package:community_portal_chat_app/data/datasource/datasource_contract.dart';
import 'package:community_portal_chat_app/models/chat.dart';
import 'package:community_portal_chat_app/viewmodels/chats_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

void main() {
  ChatsViewModel? sut;
  MockDatasource? mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = ChatsViewModel(mockDatasource!);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2022-12-09"),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockDatasource?.findAllChats()).thenAnswer((_) async => []);
    expect(await sut?.getChats(), isEmpty);
  });

  test('return list of chats', () async {
    final chat = Chat('123');
    when(mockDatasource?.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut?.getChats();
    expect(chats, isNotEmpty);
  });

  test('create a new chat when receiving message for the first time',
  () async {
    when(mockDatasource?.findChat(any)).thenAnswer((_) async => null);
    await sut?.receivedMessage(message);
    verify(mockDatasource?.addChat(any)).called(1);
  });

  test('add new message to a existing chat', () async {
    final chat = Chat('123');
    when(mockDatasource?.findChat(any)).thenAnswer((_) async => chat);
    await sut?.receivedMessage(message);
    verifyNever(mockDatasource?.addChat(any));
    verify(mockDatasource?.addMessage(any)).called(1);
  });
}