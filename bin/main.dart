import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum ConsoleColor { red, green, yellow, blue, magenta, cyan, white }

void printColored(String message, ConsoleColor color) {
  switch (color) {
    case ConsoleColor.red:
      print('\u001b[31m$message\u001b[0m'); // Red
      break;
    case ConsoleColor.green:
      print('\u001b[32m$message\u001b[0m'); // Green
      break;
    case ConsoleColor.yellow:
      print('\u001b[33m$message\u001b[0m'); // Yellow
      break;
    case ConsoleColor.blue:
      print('\u001b[34m$message\u001b[0m'); // Blue
      break;
    case ConsoleColor.magenta:
      print('\u001b[35m$message\u001b[0m'); // Magenta
      break;
    case ConsoleColor.cyan:
      print('\u001b[36m$message\u001b[0m'); // Cyan
      break;
    case ConsoleColor.white:
      print('\u001b[37m$message\u001b[0m'); // White
      break;
  }
}

Future<void> main() async {
  print('Привіт! Введи команду (translate, detect, end):');

  while (true) {
    String? command = stdin.readLineSync();

    if (command == 'end') {
      printColored('Додаток завершено.', ConsoleColor.green);
      break;
    } else if (command == 'translate' || command == 'detect') {
      print('Введіть текст:');
      String? text = stdin.readLineSync();

      if (text != null && text.isNotEmpty) {
        if (command == 'translate') {
          await translateText(text);
        } else {
          await detectLanguage(text);
        }
      } else {
        printColored('Помилка: Введений текст не може бути пустим.', ConsoleColor.red);
      }
    } else {
      printColored('Неправильна команда. Введіть translate, detect або end.', ConsoleColor.red);
    }

    print('Введіть наступну команду:');
  }
}

Future<void> translateText(String text) async {
  final String apiKey = 'b06db5cb63msh34663a0b45cca77p161fc2jsn5f3ab986628f';
  final String apiUrl = 'https://translate-plus.p.rapidapi.com/translate';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'translate-plus.p.rapidapi.com',
  };

  final Map<String, dynamic> data = {
    'text': text,
    'source': 'en',
    'target': 'uk',
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final String translation = responseBody['translations']['translation'] ?? 'Translation not available';
      printColored('Результат перекладу: $translation', ConsoleColor.blue);
    } else {
      printColored('Помилка запиту з кодом: ${response.statusCode}', ConsoleColor.red);
      printColored('Текст помилки: ${response.body}', ConsoleColor.red);
    }
  } catch (e) {
    printColored('Сталася помилка при виконанні запиту: $e', ConsoleColor.red);
  }
}

Future<void> detectLanguage(String text) async {
  final String apiKey = 'b06db5cb63msh34663a0b45cca77p161fc2jsn5f3ab986628f';
  final String apiUrl = 'https://translate-plus.p.rapidapi.com/language_detect';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'translate-plus.p.rapidapi.com',
  };

  final Map<String, dynamic> data = {
    'text': text,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final String language = responseBody['language_detection']['language'] ?? 'Language not detected';
      printColored('Визначенна мова: $language', ConsoleColor.green);
    } else {
      printColored('Помилка запиту з кодом: ${response.statusCode}', ConsoleColor.red);
      printColored('Текст помилки: ${response.body}', ConsoleColor.red);
    }
  } catch (e) {
    printColored('Сталася помилка при виконанні запиту: $e', ConsoleColor.red);
  }
}
