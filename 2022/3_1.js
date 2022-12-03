const {readFileSync} = require('fs');

const listOfSupplies = readFileSync('.\\3_input','utf-8').trimEnd();
const alphabet = 'abcdefghijklmnopqrstuvwxyz';

function splitIntoCompartments(str) {
  let first = str.substring(0, str.length/2);
  let second = str.substring(str.length/2);
  return [first, second];
}

function commonItem([first, second]) {
  for (let letter of first) {
    if (second.includes(letter)) return letter;
  }
}

let total = listOfSupplies.split('\n').map(
  splitIntoCompartments
).map(
  commonItem
).map(
  letter => {
    if(letter == letter.toUpperCase()) {
      return alphabet.indexOf(letter.toLowerCase()) + 27;
    } else {
      return alphabet.indexOf(letter.toLowerCase()) + 1;
    }
  }
).reduce((a,b) => a + b);

console.log(total);
