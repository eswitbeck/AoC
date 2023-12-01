const { readFileSync } = require("fs");

const file = readFileSync("./input", "utf-8");

const lines = file.trimEnd().split('\n');

const numberLookup = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
}

const getFirstDigit = line => {
  for (let i = 0; i < line.length; i++) {
    let buffer = "";
    for (let j = i; j < line.length; j++) {
      if (line[j].match(/\d/) && j === i) return line[j];
      buffer += line[j];
      if (numberLookup[buffer] !== undefined) return `${numberLookup[buffer]}`;
    }
  }
}

const getLastDigit = line => {
  for (let i = line.length - 1; i >= 0; i--) {
    let buffer = "";
    for (let j = i; j >= 0; j--) {
      if (line[j].match(/\d/) && j === i) return line[j];
      buffer = line[j] + buffer;
      if (numberLookup[buffer] !== undefined) return `${numberLookup[buffer]}`;
    }
  }
}

const getDigits = line => {
  const f = getFirstDigit(line);
  const l = getLastDigit(line);
  console.log(line, f, l);
  return Number(`${f}${l}`);
}
  
const solution = lines
  .map(getDigits)
  .reduce((a, b) => a + b, 0);

console.log(solution);
