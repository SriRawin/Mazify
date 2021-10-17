import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazify/2d_grid.dart';
import 'package:mazify/algorithms.dart';
import 'package:mazify/animated_button_popup.dart';
import 'package:mazify/generation_algorithms.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void disableBottomButtons() {
    setState(() {
      _disabled1 = true;
      _disabled2 = true;
      _disabled3 = true;
      _disabled4 = true;
      _disabled5 = true;
      _disabled6 = true;
    });
  }

  void enableBottomButtons() {
    setState(() {
      _disabled1 = false;
      _disabled2 = false;
      _disabled3 = false;
      _disabled4 = false;
      _disabled5 = false;
      _disabled6 = false;
    });
  }

  Color _color6 = Colors.lightGreen[500];

  bool _disabled1 = false;
  bool _disabled2 = false;
  bool _disabled3 = false;
  bool _disabled4 = false;
  bool _disabled5 = false;
  bool _disabled6 = false;

  bool drawTool = true;

  Grid grid = Grid(57, 24, 80, 10, 10, 40, 10);

  double brushSize = 0.1;

  @override
  initState() {
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String dropDownValue;
  String dropDownAlgoValue;
  @override
  Widget build(BuildContext context) {
    var popupmodel = Provider.of<PopUpModel>(context, listen: false);

    final snackBar = SnackBar(
      content: Text("Couldn't find path."),
      duration: Duration(milliseconds: 1400),
    );
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Mazify",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 500,
                ),
                Consumer<PopUpModel>(
                  builder: (_, model, __) {
                    return DropdownButton(
                      onChanged: (v) {
                        model.stop = false;
                        setActiveButton(3, context);
                        setState(() {
                          dropDownValue = v;
                          isRunning = true;
                          _generationRunning = true;
                        });
                        disableBottomButtons();
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
                              enableBottomButtons();
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
                    );
                  },
                ),
                SizedBox(
                  width: 60,
                ),
                Consumer<PopUpModel>(
                  builder: (_, model, __) {
                    return DropdownButton(
                      value: dropDownAlgoValue,
                      onChanged: (v) {
                        model.stop = false;
                        setActiveButton(3, context);
                        setState(() {
                          dropDownAlgoValue = v;
                          isRunning = true;
                          _color6 = Colors.redAccent;
                        });
                        disableBottomButtons();
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
                                setState(() {
                                  _color6 = Colors.lightGreen[500];
                                });
                                enableBottomButtons();
                                return true;
                              }
                              grid.drawPath2(lastNode);
                              return false;
                            },
                            onDrawSecondPath: (Node lastNode, int c) {
                              if (model.stop) {
                                setState(() {
                                  _color6 = Colors.lightGreen[500];
                                });
                                enableBottomButtons();
                                return true;
                              }
                              grid.drawSecondPath2(lastNode);
                              return false;
                            },
                            onFinished: (pathFound) {
                              setState(() {
                                isRunning = false;
                                _color6 = Colors.lightGreen[500];
                              });
                              enableBottomButtons();
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
                            model.selectedPathAlg = VisualizerAlgorithm.astar;
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
                    );
                  },
                ),
                Spacer(),
                AnimatedButtonWithPopUp(
                  child: Image.asset("assets/images/delete.png"),
                  color: Theme.of(context).buttonColor,
                  disabled: _disabled4,
                  onPressed: () {
                    grid.clearBoard(onFinished: () {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Selector<PopUpModel, Brush>(
                  selector: (context, model) => model.selectedBrush,
                  builder: (_, brush, __) {
                    return SizedBox(
                      child: grid.gridWidget(
                        context: context,
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//
// class OperationCountModel extends ChangeNotifier {
//   int _operations = 0;
//
//   int get operations => _operations;
//
//   set operations(int value) {
//     _operations = value;
//     notifyListeners();
//   }
// }
//
// class SettingsPage extends StatelessWidget {
//   static const double maxSpeed = 1; // milliseconds delay
//   static const double minSpeed = 400; // milliseconds delay
//   @override
//   Widget build(BuildContext context) {
//     var model = Provider.of<PopUpModel>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"),
//       ),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text('Speed of Algorithms'),
//             subtitle: Text(() {
//               switch (model.speed) {
//                 case 400:
//                   return "Slow";
//                   break;
//                 case 1:
//                   return "Fast";
//                   break;
//                 default:
//                   return "Average";
//               }
//             }()),
//             trailing: Selector<PopUpModel, int>(
//                 selector: (context, model) => model.speed,
//                 builder: (_, speed, __) {
//                   return Container(
//                     width: 200,
//                     child: Slider.adaptive(
//                       activeColor: Colors.lightBlue,
//                       min: maxSpeed,
//                       max: minSpeed,
//                       divisions: 2,
//                       value: speed.toDouble() * -1 + minSpeed + maxSpeed,
//                       onChanged: (val) {
//                         model.speed = (val * -1 + minSpeed + maxSpeed).toInt();
//                       },
//                     ),
//                   );
//                 }),
//           ),
//           ListTile(
//             title: Text('Dark Theme'),
//             trailing: Switch.adaptive(
//               onChanged: (state) {
//                 if (state) {
//                   model.brightness = Brightness.dark;
//                 } else {
//                   model.brightness = Brightness.light;
//                 }
//               },
//               value: (() {
//                 if (model.brightness == Brightness.light) {
//                   return false;
//                 }
//                 return true;
//               }()),
//             ),
//           ),
//           ListTile(
//               title: Text('Forgot the tools?'),
//               trailing: FlatButton(
//                 child: Text("Show Introduction"),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => IntroductionPage(
//                                 onDone: () {
//                                   Navigator.pop(context);
//                                 },
//                               )));
//                 },
//               ))
//         ],
//       ),
//     );
//   }
// }
