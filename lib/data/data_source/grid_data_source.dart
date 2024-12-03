import 'dart:math';

import 'package:injectable/injectable.dart';

@lazySingleton
class GridDataSource {
  Future<List<List<String>>> createGrid(int rows, int cols) async {
    return List.generate(
        rows,
        (_) => List.generate(
            cols, (_) => String.fromCharCode(65 + (Random().nextInt(26)))));
  }

  Future<bool> searchWord(String word, List<List<String>> grid) async {
    final upperWord = word.toUpperCase();

    for (var row in grid) {
      if (row.join().contains(upperWord)) return true;
    }

    for (int col = 0; col < grid[0].length; col++) {
      final column = grid.map((row) => row[col]).join();
      if (column.contains(upperWord)) return true;
    }

    return false;
  }
}
