const {readFileSync} = require('fs');

let games = readFileSync(".\\2_input",'utf-8').trimEnd();

let scores = {
  rock: 1,
  paper: 2,
  scissors: 3
}

let cipher = {
  a: 'rock',
  b: 'paper',
  c: 'scissors',
  x: 'rock',
  y: 'paper',
  z: 'scissors'
}

const playRps = (theirs, yours) => {
  let theirIndex = Object.keys(scores).indexOf(theirs);
  let yourIndex = Object.keys(scores).indexOf(yours);
  switch (true) {
    case yourIndex == (theirIndex + 1) % 3: //win
      return 6;
    case yourIndex == (theirIndex + 2) % 3: //lose
      return 0;
    default:
      return 3; //tie
  }
}

let total = games.split('\n').map(
  pair => pair.split(' ').map(
    coded => cipher[coded.toLowerCase()]
  )
).map(
  choices => {
    let theirs = choices[0], yours = choices[1];
    return playRps(theirs, yours) + scores[yours];
  }
).reduce((a,b) => a + b, 0)

console.log(total);
