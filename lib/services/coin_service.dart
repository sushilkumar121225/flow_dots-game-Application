import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static const String key = "coins";

  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> addCoins(int value) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, current + value);
  }
}
