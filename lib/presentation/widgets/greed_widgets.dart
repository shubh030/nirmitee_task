import 'package:flutter/material.dart';
import 'package:nirmitee/domain/entities/grid_entities.dart';

class GridWidget extends StatelessWidget {
  final GridEntity grid;
  final List<List<int>> wordCoordinates;

  const GridWidget({
    super.key,
    required this.grid,
    required this.wordCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    final gridData = grid.grid;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridData[0].length,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: gridData.length * gridData[0].length,
      itemBuilder: (context, index) {
        final row = index ~/ gridData[0].length;
        final col = index % gridData[0].length;

        final isHighlighted = wordCoordinates
            .any((coordinate) => coordinate[0] == row && coordinate[1] == col);

        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: isHighlighted ? Colors.green[200] : Colors.blueAccent[100],
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              gridData[row][col],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
