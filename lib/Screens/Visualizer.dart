import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazify/Algorithms/MazeAlgorithms.dart';
import 'package:mazify/Algorithms/PathAlgorithms.dart';
import 'package:mazify/Screens/2dGrid.dart';
import 'package:mazify/utils/Meta.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

class Visualizer extends StatefulWidget {
  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  bool isRunning = false;

  int _selectedButton = 1;
  bool _generationRunning = false;

  void setActiveButton(int i, BuildContext context) {
    switch (i) {
      case 1: //brush
        grid.isPanning = false;
        drawTool = true;
        setState(() {
          _selectedButton = 1;
        });
        break;
      case 2: //eraser
        grid.isPanning = false;
        drawTool = false;
        setState(() {
          _selectedButton = 2;
        });
        break;
      case 3: // pan
        grid.isPanning = true;
        setState(() {
          _selectedButton = 3;
        });
        break;
      default:
    }
  }

  bool drawTool = true;

  Grid grid = Grid(
      rows: 63,
      columns: 25,
      unitSize: 23,
      starti: 10,
      startj: 10,
      finishi: 50,
      finishj: 10);

  double brushSize = 0.1;

  String dropDownValue;
  String dropDownAlgoValue;
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text("Couldn't find path."),
      duration: Duration(milliseconds: 1400),
    );
    return Scaffold(
      backgroundColor: KgreenShade1.withOpacity(0.6),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {
            grid.clearBoard();
          },
          child: Text(
            "Mazify.",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Consumer<AlgoData>(
                  builder: (_, model, __) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 2,
                          color: KgreenShade1.withOpacity(0.8),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: HSLColor.fromColor(KgreenShade1)
                              .withLightness(
                                  (HSLColor.fromColor(KgreenShade1).lightness +
                                          0.3)
                                      .clamp(0, 1))
                              .toColor(),
                          onChanged: (v) {
                            model.stop = false;
                            setActiveButton(3, context);
                            setState(() {
                              dropDownValue = v;
                              isRunning = true;
                              _generationRunning = true;
                            });

                            grid.clearPaths();
                            //grid.fillWithWall();
                            GenerateAlgorithms.visualize(
                                algorithm: model.selectedAlg,
                                gridd: grid.nodeTypes,
                                stopCallback: () {
                                  return model.stop;
                                },
                                onShowCurrentNode: (i, j) {
                                  //grid.addNode(i, j, Brush.open);
                                  grid.putCurrentNode(i, j);
                                },
                                onRemoveWall: (i, j) {
                                  grid.removeNode(i, j, 1);
                                },
                                onShowWall: (i, j) {
                                  grid.addNode(i, j, Brush.wall);
                                },
                                speed: () {
                                  return model.speed;
                                },
                                onFinished: () {
                                  setState(() {
                                    isRunning = false;
                                    _generationRunning = false;
                                  });
                                });
                          },
                          value: dropDownValue,
                          hint: Text("Choose a Maze Pattern"),
                          items: [
                            DropdownMenuItem(
                              value: "backtracker",
                              onTap: () {
                                model.selectedAlg =
                                    GridGenerationFunction.backtracker;
                              },
                              child: Text("Backtracker maze"),
                            ),
                            DropdownMenuItem(
                              value: "recursive",
                              onTap: () {
                                model.selectedAlg =
                                    GridGenerationFunction.recursive;
                              },
                              child: Text("Recursive maze"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Consumer<AlgoData>(
                  builder: (_, model, __) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 2,
                          color: KgreenShade1.withOpacity(0.8),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: HSLColor.fromColor(KgreenShade1)
                              .withLightness(
                                  (HSLColor.fromColor(KgreenShade1).lightness +
                                          0.3)
                                      .clamp(0, 1))
                              .toColor(),
                          value: dropDownAlgoValue,
                          onChanged: (v) {
                            model.stop = false;
                            setActiveButton(3, context);
                            setState(() {
                              dropDownAlgoValue = v;
                              isRunning = true;
                            });

                            grid.clearPaths();
                            PathfindAlgorithms.visualize(
                                algorithm: model.selectedPathAlg,
                                gridd: grid.nodeTypes,
                                startti: grid.starti,
                                starttj: grid.startj,
                                finishi: grid.finishi,
                                finishj: grid.finishj,
                                onShowClosedNode: (int i, int j) {
                                  grid.addNode(i, j, Brush.closed);
                                },
                                onShowOpenNode: (int i, int j) {
                                  grid.addNode(i, j, Brush.open);
                                },
                                speed: () {
                                  return model.speed;
                                },
                                onDrawPath: (Node lastNode, int c) {
                                  if (model.stop) {
                                    setState(() {});

                                    return true;
                                  }
                                  grid.drawPath2(lastNode);
                                  return false;
                                },
                                onDrawSecondPath: (Node lastNode, int c) {
                                  if (model.stop) {
                                    setState(() {});

                                    return true;
                                  }
                                  grid.drawSecondPath2(lastNode);
                                  return false;
                                },
                                onFinished: (pathFound) {
                                  setState(() {
                                    isRunning = false;
                                  });

                                  if (!pathFound) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    // Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                });
                          },
                          hint: Text("Choose a Algorithm"),
                          items: [
                            DropdownMenuItem(
                              value: "A*",
                              onTap: () {
                                model.selectedPathAlg =
                                    VisualizerAlgorithm.astar;
                              },
                              child: Text("A*"),
                            ),
                            DropdownMenuItem(
                              value: 'Dijkstra',
                              onTap: () {
                                model.selectedPathAlg =
                                    VisualizerAlgorithm.dijkstra;
                              },
                              child: Text("Dijkstra"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12, top: 20),
              child: Selector<AlgoData, Brush>(
                selector: (context, model) => model.selectedBrush,
                builder: (_, brush, __) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return grid.gridWidget(
                      constraints: constraints,
                      onTapNode: (i, j) {
                        grid.clearPaths();
                        if (drawTool) {
                          if (brush == Brush.wall) {
                            grid.addNode(i, j, Brush.wall);
                          } else {
                            grid.hoverSpecialNode(i, j, brush);
                          }
                        } else {
                          grid.removeNode(i, j, 1);
                        }
                      },
                      onDragNode: (i, j, k, l, t) {
                        if (drawTool) {
                          if (brush != Brush.wall) {
                            grid.hoverSpecialNode(k, l, brush);
                          } else {
                            grid.addNode(k, l, brush);
                          }
                        } else {
                          grid.removeNode(k, l, 1);
                        }
                      },
                      onDragNodeEnd: () {
                        if (brush != Brush.wall && drawTool) {
                          grid.addSpecialNode(brush);
                        }
                      },
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
