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
}

const translate = (pair) => {
  let choices = pair.split(' ');
  let theirs = choices[0].toLowerCase(), yours = choices[1].toLowerCase();
  let theirIndex = Object.keys(cipher).indexOf(theirs);
  switch (yours) {
    case 'x':  //lose
      yours = Object.values(cipher)[(theirIndex + 2) % 3]
      break;
    case 'y':  //draw
      yours = Object.values(cipher)[theirIndex]
      break;
    case 'z':  //win
      yours = Object.values(cipher)[(theirIndex + 1) % 3]
      break;
  }
  return [cipher[theirs], yours]
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
  translate
).map(
  ([theirs, yours]) => playRps(theirs, yours) + scores[yours]
).reduce((a,b) => a + b, 0)

console.log(total);
