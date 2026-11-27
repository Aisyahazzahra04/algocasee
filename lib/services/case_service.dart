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

  static Future<CaseModel> loadCase04() {
    return loadCase('assets/data/cases/case_04.json');
  }

  static Future<CaseModel> loadCase05() async {
    return loadCase('assets/data/cases/case_05.json');
  }

  static Future<CaseModel> loadCase06() async {
    return loadCase('assets/data/cases/case_06.json');
  }

  static Future<CaseModel> loadCase07() async {
  return loadCase('assets/data/cases/case_07.json');
  }
  
  static Future<CaseModel> loadCase08() async {
  return loadCase('assets/data/cases/case_08.json');
  }

    static Future<CaseModel> loadCase09() async {
  return loadCase('assets/data/cases/case_09.json');
  }

}
