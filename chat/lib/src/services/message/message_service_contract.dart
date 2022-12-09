import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:flutter/material.dart';

abstract class IMessageService {
  Future<bool>? send(Message message);
  Stream<Message?>? messages({@required User? activeUser});
  dispose();
}