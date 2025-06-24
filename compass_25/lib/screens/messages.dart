// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:cupertino_compass/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../adaptive/widgets.dart' as adaptive;
import '../theme.dart';
import '../widgets/chat_bubble.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConversationListScreen();
  }
}

class Conversation {
  final String name;
  final String latestMessage;

  Conversation({required this.name, required this.latestMessage});
}

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      Conversation(
        name: 'Alex Thompson',
        latestMessage: 'Hey, how are you doing today?',
      ),
      Conversation(
        name: 'Jordan Lee',
        latestMessage: 'Just finished that report.',
      ),
      Conversation(
        name: 'Casey Rivera',
        latestMessage: 'See you at the meeting.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const TitleText(text: 'Messages')),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];

          return ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.grey.shade500,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person),
            ),
            title: Text(
              conversation.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(conversation.latestMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(name: conversation.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<({String? text, bool fromUser})> _messages = [
    (text: 'Hello!', fromUser: false),
    (text: 'Hi there!', fromUser: true),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add((text: message, fromUser: true));
        _textController.clear();
        _scrollDown();
      });
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var isFromUser = _messages[index].fromUser;
                return AdaptiveChatBubble(
                  message: _messages[index].text ?? "",
                  isUser: isFromUser,
                  iOSBackgroundColor:
                      isFromUser ? Colors.blue : Colors.grey.shade300,
                  iOSTextColor: isFromUser ? Colors.white : Colors.black,
                  androidBackgroundColor:
                      isFromUser
                          ? AppColors.chatBubbleUser
                          : AppColors.chatBubbleOther,
                  androidTextColor: Colors.black,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: adaptive.AdaptiveTextField(
                        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                        style: TextStyle(color: Colors.black),
                        controller: _textController,
                        placeholder: 'Type a message...',
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Platform.isIOS ? Icons.arrow_upward : Icons.send,
                    ),
                    onPressed: () => _sendMessage(_textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
