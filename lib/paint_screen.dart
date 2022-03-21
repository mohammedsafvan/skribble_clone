import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skribble_clone/ip.dart';
import 'package:skribble_clone/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

import 'models/my_custom_painter.dart';

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screen;
  const PaintScreen({Key? key, required this.data, required this.screen})
      : super(key: key);
  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late i_o.Socket _socket;
  Map? dataOfRoom;
  List<TouchPoint> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double selectedOpacity = 1;
  double strokeWidth = 2;

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    _socket = i_o.io(
        ipdAdress, // Your local ip address and port eg:"http://192.111.111.111:3000"
        i_o.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    _socket.connect();

    if (widget.screen == "createScreen") {
      _socket.emit("create-game", widget.data);
    } else {
      _socket.emit("join-game", widget.data);
    }
    _socket.onConnect((_) {
      _socket.on("update-room", (roomData) {
        setState(() {
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          // start the timer
        }
      });
      _socket.on("points", (point) {
        if (point["details"] != null) {
          setState(() {
            points.add(TouchPoint(
                paint: Paint()
                  ..color = selectedColor.withOpacity(selectedOpacity)
                  ..strokeWidth = strokeWidth
                  ..strokeCap = strokeType
                  ..isAntiAlias = true,
                points: Offset((point["details"]["dx"]).toDouble(),
                    (point["details"]["dy"]).toDouble())));
          });
        }
      });
      _socket.on("not-correct-game", (info) {
        print("not correct game");
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(info.toString()),
        ));
      });

      _socket.on("color-change", (colorString) {
        int value = int.parse(
          colorString,
          radix: 16,
        );
        Color oColor = Color(value);
        setState(() {
          selectedColor = oColor;
        });
      });

      _socket.on("strokeWidth-change", (value) {
        setState(() {
          strokeWidth = value;
        });
      });

      _socket.on("clear-canvas", (_) {
        setState(() {
          points.clear();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Select a color"),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      String colorString = color.toString();
                      String valueString =
                          colorString.split("(0x")[1].split(")")[0];
                      Map map = {
                        "color": valueString,
                        "roomName": dataOfRoom!["name"]
                      };
                      _socket.emit("color-change", map);
                    },
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"))
                ],
              ));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: height * 0.55,
                  color: Colors.amber,
                  child: GestureDetector(
                    onPanStart: (details) {
                      _socket.emit("paint", {
                        "details": {
                          "dx": details.localPosition.dx,
                          "dy": details.localPosition.dy,
                        },
                        "roomName": widget.data["name"]
                      });
                    },
                    onPanUpdate: (details) {
                      _socket.emit("paint", {
                        "details": {
                          "dx": details.localPosition.dx,
                          "dy": details.localPosition.dy,
                        },
                        "roomName": widget.data["name"]
                      });
                    },
                    onPanEnd: (details) {
                      _socket.emit("paint",
                          {"details": null, "roomName": widget.data["name"]});
                    },
                    child: SizedBox.expand(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: MyCustomPainter(pointsList: points),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        selectColor();
                      },
                      icon: const Icon(Icons.color_lens),
                      color: selectedColor,
                    ),
                    Expanded(
                      child: Slider(
                        min: 1.0,
                        max: 10,
                        label: "Stroke width $strokeWidth",
                        activeColor: selectedColor,
                        value: strokeWidth,
                        onChanged: (double value) {
                          Map map = {
                            "value": value,
                            "roomName": dataOfRoom!["name"]
                          };
                          _socket.emit("strokeWidth-change", map);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _socket.emit("clear-canvas",
                              {"roomName": dataOfRoom!["name"]});
                        },
                        icon: Icon(
                          Icons.layers_clear,
                          color: selectedColor,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
