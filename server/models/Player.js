const mongoose = require("mongoose");

const plalyerSchema = mongoose.Schema({
  username: {
    required: true,
    type: String,
    trim: true,
  },
  socketID: {
    type: String,
  },
  isPartyLeader: {
    type: Boolean,
    default: false,
  },
  points: {
    type: Number,
    default: 0,
  },
});

const playerModel = mongoose.model("Player", plalyerSchema);

module.exports = { playerModel, plalyerSchema };
