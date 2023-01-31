import 'package:http/http.dart' as http;
import 'dart:convert';

getSubjects() async {
  var url = Uri.https("app.homologacao.uff.br", "umm/api/hello_world");
  var response =
      await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});
  return jsonDecode(response.body);
}

Future<int> getLastPointId([int userId = 1]) async {
  var url = Uri.http("localhost:3000", "api/points/users/$userId/last_point");
  var response = await http.get(url);
  return jsonDecode(response.body) as int;
}

void main() async {
  print(getLastPointId());
}
