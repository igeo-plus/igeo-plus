import 'package:http/http.dart' as http;
import 'dart:convert';

getSubjects() async {
  var url = Uri.https("app.homologacao.uff.br", "umm/api/hello_world");
  var response =
      await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});
  return jsonDecode(response.body);
}

void main() async {
  var parsedJson = await getSubjects();
  print(parsedJson);
}
