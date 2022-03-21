import 'package:flutter/material.dart';
import 'package:skribble_clone/paint_screen.dart';
import 'package:skribble_clone/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String? _maxRoundValue;
  String? _roomSize;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundValue != null &&
        _roomSize != null) {
      Map data = {
        "username": _nameController.text,
        "name": _roomNameController.text,
        "roomSize": _roomSize,
        "maxRounds": _maxRoundValue
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) =>
              PaintScreen(data: data, screen: "createScreen"))));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill th fields!")));
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
            "Create a room",
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
          roundsDropdown(),
          const SizedBox(
            height: 29,
          ),
          sizeDropdown(),
          const SizedBox(
            height: 29,
          ),
          ElevatedButton(
            onPressed: () {
              createRoom();
            },
            child: const Text(
              "Create room",
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

  DropdownButton<String> sizeDropdown() {
    return DropdownButton<String>(
      value: _roomSize,
      focusColor: const Color(0xFFE6F4FF),
      hint: const Text(
        "Select room size",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      ),
      items: <String>[
        "2",
        "3",
        "4",
        "5",
      ]
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        setState(() {
          _roomSize = value;
        });
      },
    );
  }

  DropdownButton<String> roundsDropdown() {
    return DropdownButton<String>(
      value: _maxRoundValue,
      focusColor: const Color(0xFFE6F4FF),
      hint: const Text(
        "Select max rounds",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      ),
      items: <String>[
        "2",
        "5",
        "10",
        "15",
        "20",
      ]
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        setState(() {
          _maxRoundValue = value;
        });
      },
    );
  }
}
