import 'package:flutter/material.dart';
import 'package:skribble_clone/paint_screen.dart';
import 'package:skribble_clone/widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  void joinRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty) {
      Map data = {
        "username": _nameController.text,
        "name": _roomNameController.text
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintScreen(data: data, screen: "joinScreen")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill the fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Join a room",
            style: TextStyle(
              // color: Colors.black,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .08,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _nameController,
              hintingText: "Enter your name",
            ),
          ),
          const SizedBox(
            height: 29,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _roomNameController,
              hintingText: "Enter your Room name",
            ),
          ),
          const SizedBox(
            height: 29,
          ),
          ElevatedButton(
            onPressed: () {
              joinRoom();
            },
            child: const Text(
              "Join room",
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
          )
        ],
      ),
    );
  }
}
