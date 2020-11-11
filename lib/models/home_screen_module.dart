import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nfl_app/models/user_model.dart';

class DashBoardModule {
  int allLoads, completedLoads;
  Future load() async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/dashboard?phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: {
        'Accept': 'application/json',
      },
    );
    Map res = jsonDecode(response.body);
    allLoads = res["response"][0];
    completedLoads = res["response"][1];
  }
}
