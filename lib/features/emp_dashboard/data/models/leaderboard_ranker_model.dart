import 'package:equatable/equatable.dart';

class LeaderboardRankerModel extends Equatable {
  String rank, empID, name, cheers, imageURL, designation;

  LeaderboardRankerModel({
    this.imageURL,
    this.designation,
    this.rank,
    this.empID,
    this.name,
    this.cheers,
  });

  factory LeaderboardRankerModel.fromJson(Map<String, dynamic> json) =>
      LeaderboardRankerModel(
          rank: (json['rank'] + 1).toString(),
          empID: json['empID'],
          name: json['name']
              .toString()
              .split(" ")
              .map((element) => element
                  .toLowerCase()
                  .replaceRange(0, 1, element[0].toUpperCase()))
              .join(" "),
          imageURL: json['imageURL'],
          designation: json['designation'],
          cheers: json['cheers'].toString());

  @override
  List<Object> get props => [rank, empID, name, cheers];
}
