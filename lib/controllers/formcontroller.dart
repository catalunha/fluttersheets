import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:fluttersheets/models/feedbackform.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwz5LLFmb6CbuerGMriwXV4DulwsmHiGw7Sn2vZk4j7FTnwWwA/exec";
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    // Map<String, String> _headers = {
    //   // 'Content-Type': 'application/json;charset=UTF-8',
    //   'Charset': 'utf-8'
    // };
    print(feedbackForm.toJson());

    try {
      await http.post(URL, body: {
        'name': 'aaa',
        'email': 'aaa@gmail.com',
        'mobileNo': '1234567890',
        'feedback': 'aaa bbbb ccccc'
      }).then((response) async {
        // await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        print(response.statusCode);
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
