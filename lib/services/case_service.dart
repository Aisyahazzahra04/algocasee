import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/case_model.dart';

class CaseService {
  static Future<CaseModel> loadCase(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);

    final Map<String, dynamic> jsonData =
        jsonDecode(jsonString);

    return CaseModel.fromJson(jsonData);
  }

  static Future<CaseModel> loadCase01() {
    return loadCase('assets/data/cases/case_01.json');
  }

  static Future<CaseModel> loadCase02() {
    return loadCase('assets/data/cases/case_02.json');
  }

    static Future<CaseModel> loadCase03() {
    return loadCase('assets/data/cases/case_03.json');
  }
}
