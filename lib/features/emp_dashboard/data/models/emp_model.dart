class EmployeeModel {
  String id, name, imageURL, designation, about, rank, totalCheers;
  List<String> badges;
  Map<String, String> traitCheers;

  EmployeeModel({
    this.id,
    this.name,
    this.imageURL,
    this.designation,
    this.about,
    this.rank,
    this.totalCheers,
    this.badges,
    this.traitCheers,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
      id: json["id"],
      name: json["name"],
      imageURL: json["imageURL"],
      designation: json["designation"],
      about: json["about"],
      badges: json.containsKey("badges")
          ? Map<String, String>.from(json["badges"]).values.toList()
          : []);
}
