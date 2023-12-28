import 'dart:async';

import 'package:cmc/Screens/Groups/AI/FirebaseChatGPTmessages.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  bool isLoading = false;
  List<ChatGPTMessages> messages = [];
  TextEditingController _message = TextEditingController();
  final StreamController<List<ChatGPTMessages>> _messagesController =
      StreamController<List<ChatGPTMessages>>();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 100,
        title: Text(
          'ChatWithAI',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: _buildMessage(context),
            ),
            isLoading
                ? Container(
                    height: 50,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [
                        Colors.yellow,
                      ],
                      strokeWidth: 0.1,
                    ))
                : Container(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _message,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding:
                            EdgeInsets.only(left: screenWidth * 0.2),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (_message.text.isNotEmpty) {
                        update(_message.text, context);
                      }
                      _message.clear();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  update(String message, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    ChatGPTMessages userMessage =
        ChatGPTMessages(message: message, isUser: true);
    messages.add(userMessage);
    _messagesController.add(List.from(messages));
    ChatGPTMessages aimessage = await sendMessage(_message.text);
    messages.add(aimessage);
    _message.clear();
    _messagesController.add(List.from(messages));
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildMessage(BuildContext context) {
    return StreamBuilder<List<ChatGPTMessages>>(
      stream: _messagesController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No messages available.'));
        } else {
          List<ChatGPTMessages> reversedMessages =
              snapshot.data!.reversed.toList();
          return Stack(children: [
            ListView.builder(
              reverse: true,
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(reversedMessages[index]);
              },
            ),
          ]);
        }
      },
    );
  }

  Widget _buildMessageItem(ChatGPTMessages message) {
    Alignment alignment =
        !message.isUser ? Alignment.centerLeft : Alignment.centerRight;
    Color _color = (message.isUser)
        ? const Color.fromARGB(255, 172, 247, 175)
        : Colors.white;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: (message.isUser)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (message.isUser)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 12, left: 12, right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
