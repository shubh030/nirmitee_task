import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nirmitee/presentation/cubits/grid_cubit/grid_cubit.dart';
import 'package:nirmitee/presentation/widgets/greed_widgets.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final _rowsController = TextEditingController();
  final _colsController = TextEditingController();
  final _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    const int rows = 4;
    const int cols = 4;
    context.read<GridCubit>().createGrid(rows, cols);
    super.initState();
  }

  @override
  void dispose() {
    _rowsController.dispose();
    _colsController.dispose();
    _searchController.dispose();
    _audioPlayer.dispose();
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
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;

            if (isPortrait) {
              return _buildPortraitLayout();
            } else {
              return _buildLandscapeLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        _buildInputFields(),
        const SizedBox(height: 16),
        _buildSearchField(),
        const SizedBox(height: 16),
        _buildGrid(),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGrid(),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildInputFields(),
              const SizedBox(height: 16),
              _buildSearchField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Row(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Generate Grid'),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) {
        return TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search Word',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                final searchText = _searchController.text;
                if (searchText.length >= 2) {
                  context.read<GridCubit>().searchWord(searchText);
                }
              },
              icon: const Icon(Icons.search),
            ),
          ),
          onSubmitted: (value) async {
            if (value.length >= 2) {
              await context.read<GridCubit>().searchWord(value);
            }
          },
        );
      },
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: BlocConsumer<GridCubit, GridState>(
        listener: (context, state) {
          if (state is GridCreated && _searchController.text.isNotEmpty) {
            if (state.wordCoordinates?.isEmpty ?? true) {
              _showSnackbar("Word not found!", Colors.red);
              _playAudio("sound/fail.mp3");
            } else {
              _showSnackbar("Word found!", Colors.green);
              _playAudio("sound/success.mp3");
            }
          }
        },
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
    );
  }
}
