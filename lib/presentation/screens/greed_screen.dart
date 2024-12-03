import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nirmitee/presentation/cubits/grid_cubit/grid_cubit.dart';
import 'package:nirmitee/presentation/widgets/greed_widgets.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final _rowsController = TextEditingController();
  final _colsController = TextEditingController();
  final _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _rowsController.dispose();
    _colsController.dispose();
    _searchController.dispose();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  void _playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _showSnackbar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Search Grid')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rowsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Rows',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _colsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Columns',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final rows = int.tryParse(_rowsController.text) ?? 4;
                    final cols = int.tryParse(_colsController.text) ?? 4;
                    context.read<GridCubit>().createGrid(rows, cols);
                  },
                  child: const Text('Generate Grid'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Word',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  await context.read<GridCubit>().searchWord(value);
                  final currentState = context.read<GridCubit>().state;

                  if (currentState is GridCreated &&
                      (currentState.wordCoordinates?.isEmpty ?? true)) {
                    // Word not found
                    _showSnackbar("Word not found!", Colors.red);
                    _playAudio("assets/fail.mp3");
                  } else if (currentState is GridCreated) {
                    // Word found
                    _showSnackbar("Word found!", Colors.green);
                    _playAudio("assets/success.mp3");
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<GridCubit, GridState>(
                builder: (context, state) {
                  if (state is GridLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GridCreated) {
                    return GridWidget(
                      grid: state.grid,
                      wordCoordinates: state.wordCoordinates ?? [],
                    );
                  }
                  return const Center(child: Text('Create a grid to start.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
