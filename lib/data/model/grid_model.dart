import 'package:nirmitee/domain/entities/grid_entities.dart';

class GridModel extends GridEntity {
  GridModel(super.grid);

  factory GridModel.fromJson(Map<String, dynamic> json) {
    return GridModel(
      List<List<String>>.from(
        json['grid'].map((row) => List<String>.from(row)),
      ),
    );
  }
}
