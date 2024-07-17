import 'package:chat_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_services.dart';

class GetDataRepo {
  final DBServices _dbServices = DBServices();
  Future<UserModel?>? getDataForSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    UserModel userModel = await _dbServices.fetchDatafromDB("users", uid!);
    return userModel;
  }
}
