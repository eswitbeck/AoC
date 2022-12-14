const {readFileSync} = require('fs')

function readFile(filename) {
  return readFileSync(filename, 'utf-8').split(/\n\s/);
}

const elves = readFile(".\\1_input");

const calorieList = [];

for (let elf of elves) {
  const snacks = elf.split("\n");
  if (elf === elves[elves.length - 1]) snacks.pop(); //remove pesky null line in parse

  let calorieCount = 0;

  for (let snack of snacks) {
    calorieCount += Number(snack);
  }

  calorieList.push(calorieCount);
}

let largest = calorieList.reduce((a,b) => Math.max(a,b), -Infinity);

console.log(`Greatest number of calories held: ${largest}.`);

let sortedCal = calorieList.sort((a,b) => b - a);
let topThree = sortedCal.slice(0,3);

console.log(`Total of the top three: ${topThree.reduce((a,b) => a + b, 0)}.`);

return;
