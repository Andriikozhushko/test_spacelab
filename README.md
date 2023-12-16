Так як ендпоінт, який було надано в листі з тестовим завданням, а саме (https://rapidapi.com/googlecloud/api/google-translate1/), не є функціонованим, а саме з проблемою API. З кодом
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String apiKey = 'b06db5cb63msh34663a0b45cca77p161fc2jsn5f3ab986628f';
  final String apiUrl = 'https://google-translate1.p.rapidapi.com/language/translate/v2';

  Map<String, String> headers = {
    'content-type': 'application/x-www-form-urlencoded',
    'Accept-Encoding': 'application/gzip',
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com',
  };

  Map<String, String> body = {
    'q': 'Hello, world!',
    'target': 'es',
    'source': 'en',
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
    } else {
      print('Error: ${response.statusCode}');
      print(response.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Є помилка Error: 403 
{"error":{"code":403,"message":"Method doesn't allow unregistered callers (callers without established identity). Please use API Key or other form of API consumer identity to call this API.","errors":[{"message":"Method doesn't allow unregistered callers (callers without established identity). Please use API Key or other form of API consumer identity to call this API.","domain":"global","reason":"forbidden"}],"status":"PERMISSION_DENIED"}} 

Це означає, що код помилки 403 вказує на те, що запит був відхилений сервером, оскільки він не отримав достатньої інформації про аутентифікацію. 
Також я впевнений, що мій ключ є правильним, та обліковий запис RapidApi.com вказано правильно, та підписка дійсна. 
Тому мною було прийняте рішення обрати інший ендпоінт, з сайту Rapidapi, а саме Translate Plus, який також задовільняє вимоги тестового завдання. А саме POST запити на команду translate, та detect.

Додаткове завдання було зроблене за допомогою функції printColored, яка виводить текст у консоль із заданим кольором.

P.S. Я не заперечую, що можливо API гугл-перекладача було неробоче ТІЛЬКИ в той час, коли я працював над кодом.
