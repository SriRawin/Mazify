import 'package:flutter/material.dart';
import 'package:mazify/Screens/2dGrid.dart';

class AlgoData extends ChangeNotifier {
  int _speed = 1;

  int get speed => _speed;

  set speed(value) {
    _speed = value;
    notifyListeners();
  }

  bool _stop = false;

  bool get stop => _stop;

  set stop(value) {
    _stop = value;
    notifyListeners();
  }

  Brush selectedBrush = Brush.wall;

  GridGenerationFunction selectedAlg = GridGenerationFunction.recursive;

  VisualizerAlgorithm selectedPathAlg = VisualizerAlgorithm.astar;

  void setActiveAlgorithm(int i, BuildContext context) {
    switch (i) {
      case 1: //maze
        selectedAlg = GridGenerationFunction.backtracker;
        notifyListeners();
        break;
      case 2: //recursive
        selectedAlg = GridGenerationFunction.recursive;
        notifyListeners();
        break;
      default:
    }
  }

  void setActivePAlgorithm(int i) {
    switch (i) {
      case 1: //astar
        selectedPathAlg = VisualizerAlgorithm.astar;
        notifyListeners();
        break;
      case 2: //dijkstra
        selectedPathAlg = VisualizerAlgorithm.dijkstra;
        notifyListeners();
        break;
      default:
    }
  }
}
