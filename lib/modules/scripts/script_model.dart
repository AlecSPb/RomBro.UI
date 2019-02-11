class ScriptModel {
  String identifier;
  String description;
  String name;

  ScriptModel({this.identifier, this.description, this.name});

  factory ScriptModel.fromJson(Map<String, dynamic> json) {
    return ScriptModel(
        identifier: json["identifier"], description: json['description'], name: json["name"]);
  }
}

class ScriptModelList {
  final List<ScriptModel> allCommands;
  ScriptModelList({this.allCommands});
  factory ScriptModelList.fromJson(List<dynamic> json) {
    List<ScriptModel> commands = new List<ScriptModel>();
    commands = json.map((i) => ScriptModel.fromJson(i)).toList();
    return new ScriptModelList(allCommands: commands);
  }
}
