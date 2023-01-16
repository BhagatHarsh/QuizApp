import 'dart:convert';
import 'dart:io';

// Use the response object to process the data
void main() {
  printResponse();
}

void printResponse() async {
  HttpClient client = HttpClient();
  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://beta-trivia.bongo.best/?type=boolean&limit=5"));
  HttpClientResponse response = await request.close();
  String responseBody = await response.transform(utf8.decoder).join();
  print(jsonDecode(responseBody)[0]['question']);
}
