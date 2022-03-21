const mongoose = require("mongoose");
const {plalyerSchema} = require("./Player");

const roomSchema = mongoose.Schema({
  word: {
    required: true,
    type: String,
  },
  name: {
    required: true,
    type: String,
    unique: true,
    trim: true,
  },
  roomSize: {
    required: true,
    type: Number,
    default: 4,
  },
  maxRounds: {
    required: true,
    type: Number,
  },
  currentRound: {
    required: true,
    type: Number,
    default: 1,
  },
  players: [plalyerSchema],
  isJoin: {
    type: Boolean,
    default: true,
  },
  turn: plalyerSchema,
  turnIndex: {
    type: Number,
    default: 0,
  },
});

const roomModel = mongoose.model("Room", roomSchema);
module.exports = roomModel;
