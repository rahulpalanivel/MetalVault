import 'package:http/http.dart' as http;
import 'dart:convert'; 

class Getgoldrateapi {
  
  static var data;
  static var header = {
        "x-access-token": "goldapi-6z320a19m8xe0bmr-io",
        "Content-Type": "application/json"
  };

  static Future<void> fetchData() async {
    
    final url = 'https://www.goldapi.io/api/XAU/INR';
    final response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
        data = jsonDecode(response.body)['price_gram_24k'];
    } else {
      throw Exception('Failed to load Data');
    }
  }
}