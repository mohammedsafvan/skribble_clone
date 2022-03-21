const getWord = () => {
  const adjectives = ["scissor", "computer", "phone", "pen", "book", "bag","cup"];

  return adjectives[Math.floor(Math.random() * adjectives.length)];
};

module.exports = getWord;
