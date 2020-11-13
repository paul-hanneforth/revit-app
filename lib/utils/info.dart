import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> createInfoFile() async {

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  final File file = File("$path/info.json");

  file.create();

}
Future<void> setInfoFile(String property, dynamic key) async {

  Map<String, dynamic> jsonResult = await readInfoFile();
  jsonResult[property] = key;

  final String content = json.encode(jsonResult);

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  final File file = File("$path/info.json");
  final bool fileExists = await file.exists();
  if(!fileExists) await createInfoFile();

  await file.writeAsString(content);

}
Future<bool> infoFileExists() async {

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  final File file = File("$path/info.json");
  final bool fileExists = await file.exists();

  return fileExists;

}
Future<Map<String, dynamic>> readInfoFile() async {
  if((await infoFileExists() == false)) createInfoFile();

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;

  final File file = File("$path/info.json");

  final String content = await file.readAsString();
  if(content == "") return Map.from({});
  final Map<String, dynamic> jsonResult = json.decode(content);

  return jsonResult;

}