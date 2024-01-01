import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cmc/Utills/Constant.dart';

class ChatGPTMessages {
  String message;
  bool isUser;

  ChatGPTMessages({required this.message, required this.isUser});
}

Future<ChatGPTMessages> sendMessage(String message) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Constant.api_key}',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.7
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final Map<String, dynamic>? responseMessage = data['choices'][0]['message'];
    final String? responseText = responseMessage?['content'];

    if (responseText != null) {
      ChatGPTMessages responseModel =
          ChatGPTMessages(message: responseText, isUser: false);
      return responseModel;
    } else {
      throw Exception('Received null value for text from GPT-3 API');
    }
  } else {
    throw Exception(
        'Failed to get response from GPT-3 API. Status Code: ${response.statusCode}');
  }
}
