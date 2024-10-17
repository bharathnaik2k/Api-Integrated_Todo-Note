import 'package:http/http.dart' as http;

getTodo() {
  Future<dynamic> gettodo() async {
    var url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    var uri = Uri.parse(url);
    var response = await http.get(uri);
  }
}
