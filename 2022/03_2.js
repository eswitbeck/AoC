const {readFileSync} = require('fs');

const listOfSupplies = readFileSync('.\\3_input','utf-8').trimEnd();
const alphabet = 'abcdefghijklmnopqrstuvwxyz';

function splitIntoTrios (list) {
  let chunkedArray = [];
  for (let i = 0; i < list.length; i += 3) {
    chunkedArray.push(list.slice(i, i + 3));
  }
  return chunkedArray;
}

function commonItem([first, second, third]) {
  for (let letter of first) {
    if (second.includes(letter) && third.includes(letter)) return letter;
  }
}

function letterValue (letter) {
  if(letter == letter.toUpperCase()) {
    return alphabet.indexOf(letter.toLowerCase()) + 27;
  } else {
    return alphabet.indexOf(letter.toLowerCase()) + 1;
  }
}

let total = splitIntoTrios(listOfSupplies.split('\n'))
  .map(commonItem)
  .map(letterValue)
  .reduce((a,b) => a + b);

console.log(total);
