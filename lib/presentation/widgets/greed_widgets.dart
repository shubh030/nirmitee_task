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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final crossAxisCount = gridData[0].length;
    final maxItemWidth = screenWidth / crossAxisCount;
    final maxItemHeight = screenHeight / gridData.length;

    final itemSize =
        maxItemWidth < maxItemHeight ? maxItemWidth : maxItemHeight;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: gridData.length * gridData[0].length,
      itemBuilder: (context, index) {
        final row = index ~/ gridData[0].length;
        final col = index % gridData[0].length;

        final isHighlighted = wordCoordinates
            .any((coordinate) => coordinate[0] == row && coordinate[1] == col);

        return Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isHighlighted ? Colors.green[200] : Colors.blueAccent[100],
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              gridData[row][col],
              style: const TextStyle(
                fontSize: 16,
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
