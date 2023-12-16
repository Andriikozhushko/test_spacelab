import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum ConsoleColor {
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  brightBlack,
  brightRed,
  brightGreen,
  brightYellow,
  brightBlue,
  brightMagenta,
  brightCyan,
  brightWhite,
}

void printColored(String message, ConsoleColor color) {
  String ansiColorCode = '0';

  switch (color) {
    case ConsoleColor.black:
      ansiColorCode = '30';
      break;
    case ConsoleColor.red:
      ansiColorCode = '31';
      break;
    case ConsoleColor.green:
      ansiColorCode = '32';
      break;
    case ConsoleColor.yellow:
      ansiColorCode = '33';
      break;
    case ConsoleColor.blue:
      ansiColorCode = '34';
      break;
    case ConsoleColor.magenta:
      ansiColorCode = '35';
      break;
    case ConsoleColor.cyan:
      ansiColorCode = '36';
      break;
    case ConsoleColor.white:
      ansiColorCode = '37';
      break;
    case ConsoleColor.brightBlack:
      ansiColorCode = '90';
      break;
    case ConsoleColor.brightRed:
      ansiColorCode = '91';
      break;
    case ConsoleColor.brightGreen:
      ansiColorCode = '92';
      break;
    case ConsoleColor.brightYellow:
      ansiColorCode = '93';
      break;
    case ConsoleColor.brightBlue:
      ansiColorCode = '94';
      break;
    case ConsoleColor.brightMagenta:
      ansiColorCode = '95';
      break;
    case ConsoleColor.brightCyan:
      ansiColorCode = '96';
      break;
    case ConsoleColor.brightWhite:
      ansiColorCode = '97';
      break;
  }

  print('\u001b[${ansiColorCode}m$message\u001b[0m');
}

Future<void> main() async {
  printColored('Привет! Введите команду (translate, detect, end):', ConsoleColor.brightCyan);

  while (true) {
    String? command = stdin.readLineSync();

    if (command == 'end') {
      printColored('Приложение завершено.', ConsoleColor.brightGreen);
      break;
    } else if (command == 'translate' || command == 'detect') {
      printColored('Введите текст:', ConsoleColor.brightYellow);
      String? text = stdin.readLineSync();

      if (text != null && text.isNotEmpty) {
        if (command == 'translate') {
          await translateText(text);
        } else {
          await detectLanguage(text);
        }
      } else {
        printColored('Ошибка: Введенный текст не может быть null или пустым.', ConsoleColor.brightRed);
      }
    } else {
      printColored('Неверная команда. Пожалуйста, введите translate, detect или end.', ConsoleColor.brightRed);
    }

    printColored('Введите следующую команду:', ConsoleColor.brightCyan);
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
    'target': 'ru',
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
      printColored('Результат перевода: $translation', ConsoleColor.brightBlue);
    } else {
      printColored('Ошибка запроса с кодом: ${response.statusCode}', ConsoleColor.brightRed);
      printColored('Текст ошибки: ${response.body}', ConsoleColor.brightRed);
    }
  } catch (e) {
    printColored('Произошла ошибка при выполнении запроса: $e', ConsoleColor.brightRed);
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
      printColored('Определенный язык: $language', ConsoleColor.brightGreen);
    } else {
      printColored('Ошибка запроса с кодом: ${response.statusCode}', ConsoleColor.brightRed);
      printColored('Текст ошибки: ${response.body}', ConsoleColor.brightRed);
    }
  } catch (e) {
    printColored('Произошла ошибка при выполнении запроса: $e', ConsoleColor.brightRed);
  }
}
