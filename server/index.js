const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const app = express();
var server = http.createServer(app);
const io = require("socket.io")(server);
const getWord = require("./api/getWord");
const { db } = require("./db");
const Room = require("./models/Room");

const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Mongodb
const DB = db; // mongodb link with username and password eg:"mongodb+srv://testuser:testpassword@cluster4.k83cu.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful!");
  })
  .catch((e) => {
    console.log(e);
  });

io.on("connection", (socket) => {
  console.log("Client connected");

  // Creating a game/room
  socket.on("create-game", async ({ username, name, maxRounds, roomSize }) => {
    try {
      const existingRoom = await Room.findOne({ name });
      if (existingRoom) {
        console.log("existing");
        socket.emit("not-correct-game", "Room with the name already exists!");
        return;
      }
      let room = new Room();
      const word = getWord();
      room.word = word;
      room.name = name;
      room.roomSize = roomSize;
      room.maxRounds = maxRounds;

      let player = {
        username,
        socketID: socket.id,
        isPartyLeader: true,
      };
      room.players.push(player);
      room = await room.save();
      socket.join(name);
      io.to(name).emit("update-room", room);
    } catch (e) {
      console.log(e);
    }
  });

  // Join game
  socket.on("join-game", async ({ username, name }) => {
    try {
      let room = await Room.findOne({ name });
      if (!room) {
        socket.emit("not-correct-game", "Room with the name is not existing!");
        return;
      }
      if (room.isJoin) {
        let player = {
          username,
          socketID: socket.id,
        };
        room.players.push(player);
        socket.join(name);
        if (room.players.length === room.roomSize) {
          room.isJoin = false;
        }
        room.turn = room.players[room.turnIndex];
        room = await room.save();
        io.to(name).emit("update-room", room);
      } else {
        socket.emit("not-correct-game", "The game is in progress!");
      }
    } catch (error) {}
  });

  ////////// White Board socket events

  socket.on("paint", ({ details, roomName }) => {
    io.to(roomName).emit("points", { details: details });
  });

  socket.on("color-change", ({ color, roomName }) => {
    io.to(roomName).emit("color-change", color);
  });

  socket.on("strokeWidth-change", ({ value, roomName }) => {
    io.to(roomName).emit("strokeWidth-change", value);
  });

  socket.on("clear-canvas", ({ roomName }) => {
    console.log(roomName);
    io.to(roomName).emit("clear-canvas");
  });
  ////////////// End///////White Board socket events
});
server.listen(port, () => {
  console.log("server started running on port :" + port);
});
