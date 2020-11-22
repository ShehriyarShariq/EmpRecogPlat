class EmployeeModel {
  String uid, id, name, imageURL, designation, about, rank, totalCheers;
  List<String> badges;
  Map<String, String> traitCheers;

  Map<String, String> alreadyVoted;

  EmployeeModel({
    this.uid,
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
        name: json["name"]
            .toString()
            .split(" ")
            .map((element) => element
                .toLowerCase()
                .replaceRange(0, 1, element[0].toUpperCase()))
            .join(" "),
        imageURL: json["imageURL"],
        designation: json["designation"],
        about: json["about"],
      );
}
