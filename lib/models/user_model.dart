import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfl_app/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static String _number;
  static String _code;
  static String image_path;

  static const key = 'an8il9wi5ngg00s1';

  static const Map headers = {
    'Accept': 'application/json',
  };

  static User user;

  static Future<String> init() async {
    var sh = await SharedPreferences.getInstance();
    var number = sh.getString("number");

    if (number == null || number.isEmpty) throw Exception("No number");

    Response response = await get(
      "https://www.itruckdispatch.com/api/login?phone=$number&otpflag=1&apikey=$key",
      headers: {
        'Accept': 'application/json',
      },
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      // user = User.fromMap(data["response"]..["phone"] = number);
      var user_data = data["response"];
      user = User.fromMap(user_data);
    }
    return null;
  }

  static Future<String> sendOtpToNumber(String number) async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/sendotpviaphone?phone=${number.replaceAll(' ', "")}&apikey=$key",
      headers: {
        'Accept': 'application/json',
      },
    );

    print("SEND OTP TO NUMBER " + response.body);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);

      _number = data["response"]["phone"].toString();
      _code = data["response"]["otp"].toString();
      return "";
    } else if (response.statusCode == 500) {
      print("SEND OTP TO NUMBER " + jsonDecode(response.body)["error"]);
      throw Exception("invalid number");
    } else {
      print("SEND OTP TO NUMBER " + jsonDecode(response.body)["error"]);
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }
  static Future<String> verifyDevice(String deviceId) async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/verifydevice?phone=${user.phone}&apikey=${key}&deviceid=${deviceId}",
      headers: {
        'Accept': 'application/json',
      },
    );
    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      return data["response"];
    }
  }
  static Future<String> updateDevice(String deviceId) async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/devicedetails?phone=${user.phone}&apikey=${key}&deviceid=${deviceId}",
      headers: {
        'Accept': 'application/json',
      },
    );
    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      return data["response"]["deviceid"];
    }
  }

  static Future checkCode(String code) async {
    if (code.isEmpty) {
      throw Exception("Enter Otp Code Please");
    } else if (code != _code) {
      throw Exception("Invalid verification code");
    }

    var response = await http.get(
      "https://www.itruckdispatch.com/api/login?phone=$_number&otpflag=1&apikey=$key",
      headers: {
        'Accept': 'application/json',
      },
    );

    Map data = jsonDecode(response.body);

    user = User.fromMap(data["response"]..["phone"] = _number);
    var sh = await SharedPreferences.getInstance();
    sh.setString("number", _number);
    return;
  }

  static Future<User> withPhone(String phone) async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/profile?phone=$phone&apikey=$key",
      headers: {
        'Accept': 'application/json',
      },
    );

    Map data = jsonDecode(response.body);

    var u = User.fromMap(data["response"]..["phone"] = phone);
    return u;
  }

  static Future<Response> uploadImage() async {
    var image = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return null;

    File f = File(image.path);

    // var task = await FirebaseStorage.instance
    //     .ref()
    //     .child("images/${image.path.split("/").last}")
    //     .putFile(f)
    //     .onComplete;

    // String url = await task.ref.getDownloadURL();

    // var post =
    //     "https://www.itruckdispatch.com/api/profilepicupdate?driverid=${user.id}&apikey=$key&file=$url";
    var post =
        "https://www.itruckdispatch.com/api/profilepicupdate";

    // var response = await http.post(
    //   post,
    //   headers: {
    //     'Accept': 'application/json',
    //     "Content-Type":
    //         "multipart/form-data;boundary=----WebKitFormBoundaryyrV7KO0BoCBuDbTL"
    //   },
    // );
    var request = http.MultipartRequest('POST', Uri.parse(post));
    request.fields['driverid'] = "${user.id}";
    request.fields['apikey'] = "${key}";
    request.headers["Accept"] = "*/*";
    request.headers["Content-Type"] = "multipart/form-data;boundary=----WebKitFormBoundaryyrV7KO0BoCBuDbTL";
    request.files.add(
      http.MultipartFile(
        'file',
        File(image.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: image.path.split("/").last
        )
      );
    var response = await request.send();
    return http.Response.fromStream(response);
          // http.Response.fromStream(result).then((response){
          //   if(response.statusCode == 200){
          //     Map res = jsonDecode(response.body);
          //     image_path = res["response"]["img"];
          //     print("imagepath:---------${image_path}");
              
          //     return image_path;
          //   }
          // });
        // response.stream.transform(utf8.decoder).listen((value) {
          
        
        //   return res;
          
        // });
        
        // await init();
  }
    
    // 999078802800
    
    //  Future<Map> updateProfilePicture(PickedFile image) async {
    //    final userid = user.id;
    //    final url = Uri.https(
    //      "https://www.itruckdispatch.com",
    //      '/api/profilepicupdate',
    //      {
    //        'apikey': key,
    //        'userid': userid.toString(),
    //      },
    //    );
    //
    //    final mimeType = mime(image.path).split('/');
    //
    //    final imageUploadRequest = http.MultipartRequest('POST', url);
    //    imageUploadRequest.headers['Content-Type'] =
    //        "multipart/form-data;boundary=----WebKitFormBoundaryyrV7KO0BoCBuDbTL";
    //    imageUploadRequest.headers['Accept'] = "*/*";
    //
    //    final file = await http.MultipartFile.fromPath(
    //      'file',
    //      image.path,
    //      filename: image.path.split("/").last,
    //      contentType: MediaType(
    //        mimeType[0],
    //        mimeType[1],
    //      ),
    //    );
    //
    //    imageUploadRequest.files.add(file);
    //
    //    final streamResponse = await imageUploadRequest.send();
    //    final resp = await http.Response.fromStream(streamResponse);
    //
    //    if (resp.statusCode == 200) {
    //      return json.decode(resp.body);
    //    } else {
    //      return {
    //        'responseMessage': 'ERROR',
    //        'response': "Couldn't upload your image"
    //      };
    //    }
    //  }

    static Future<int> editProfile(String driverid, String drivingSince, String phone, String duty, String truckNumber, String truckModel, String lisence, String email, String name, String address) async {
      print("user_phone:-----------${phone}");
      Response response = await get(
        "https://www.itruckdispatch.com/api/editprofile?driverid=${driverid}&drivingsince=${drivingSince}&phone=${phone}&dutyclass=${duty}&trucknumber=${truckNumber}&truckmodel=${truckModel}&license=${lisence}&email=${email}&name=${name}&address=${address}&apikey=${key}",
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        var user_data = data["response"];
        user = User.fromMap(user_data);
        return response.statusCode;
      }
      else{
        return null;
      }
    }
}
    
    // mixin StreamResponse {
// }
