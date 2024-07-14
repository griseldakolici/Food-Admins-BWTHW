import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpactService {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  static String sleepEndpoint = 'data/v1/sleep/patients/';
  static String stepEndpoint = 'data/v1/steps/patients/';
  static String caloriesEndpoint = 'data/v1/calories/patients/';
  static String exerciseEndpoint = 'data/v1/exercise/patients/';
  static String heartEndpoint = 'data/v1/resting_heart_rate/patients/';

  static String username = 'hGYSAA5QpP';
  static String password = '12345678!';
  static String patientUsername = 'Jpefaq6m58';

  // Method to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  static Future<int?> authorize() async {
    final url = baseUrl + tokenEndpoint;
    final body = {'username': username, 'password': password};
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
      print("Authorization successful: Access and refresh tokens stored.");
    } else {
      print("Authorization failed with status code: ${response.statusCode}");
    }
    return response.statusCode;
  }

  // Method to refresh the JWT tokens and store them in SharedPreferences
  static Future<int> refreshTokens() async {
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    if (refresh == null) {
      print("No refresh token found, user needs to re-login.");
      return 401; // Unauthorized
    }

    final url = baseUrl + refreshEndpoint;
    final body = {'refresh': refresh};
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
      print("Tokens successfully refreshed.");
    } else {
      print("Token refresh failed with status code: ${response.statusCode}");
    }
    return response.statusCode;
  }

  // Ensure that the user is authorized by checking and refreshing tokens if necessary
  static Future<void> ensureAuthorized() async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    var refresh = sp.getString('refresh');

    if (access == null || JwtDecoder.isExpired(access)) {
      print("Access token is expired or null, attempting to refresh.");
      if (refresh == null) {
        print("No refresh token found, authorizing...");
        await authorize();
      } else {
        int refreshStatus = await refreshTokens();
        if (refreshStatus != 200) {
          print("Failed to refresh tokens, authorizing...");
          await authorize();
        }
      }
    }
  }

  // Method to fetch step data from the server
  static Future<dynamic> fetchStepData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ensureAuthorized();
      access = sp.getString('access');
    }

    final url = '$baseUrl$stepEndpoint$patientUsername/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    return result;
  }

  // Method to fetch sleep data from the server
  static Future<dynamic> fetchSleepData(String start, String end) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ensureAuthorized();
      access = sp.getString('access');
    }

    final url = '$baseUrl$sleepEndpoint$patientUsername/daterange/start_date/$start/end_date/$end';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Fetching sleep data from URL: $url with headers: $headers');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error fetching sleep data: StatusCode=${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  // Method to fetch calories data from the server
  static Future<dynamic> fetchCaloriesData(String day) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ensureAuthorized();
      access = sp.getString('access');
    }

    final url = '$baseUrl$caloriesEndpoint$patientUsername/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    return result;
  }

  // Method to fetch exercise data from the server
  static Future<dynamic> fetchExerciseData(String start, String end) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ensureAuthorized();
      access = sp.getString('access');
    }

    final url = '$baseUrl$exerciseEndpoint$patientUsername/daterange/start_date/$start/end_date/$end';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.statusCode);
    
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    return result;
  }

  // Method to fetch heart data from the server
  static Future<dynamic> fetchHeartData(String start, String end) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await ensureAuthorized();
      access = sp.getString('access');
    }

    final url = '$baseUrl$heartEndpoint$patientUsername/daterange/start_date/$start/end_date/$end';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.statusCode);
    
    var result;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    return result;
  }
}
