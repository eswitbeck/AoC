const { readFileSync } = require('fs');
const input = readFileSync('./input', 'utf8').trimEnd().split('\n');

const regex = /(\d{1,2})-(\d{1,2}) (.{1}): (.*)/

const sets = input.map(s => s.match(regex))

const isValidList1 = ([_, l, h, c, s, ...r]) => {
  const low = Number(l);
  const high = Number(h);
  let count = 0
  for (let i = 0; i < s.length; i++) {
    if (s[i] === c) count++;
  }
  return count >= low && count <= high;
}

const isValidList2 = ([_, l, h, c, s, ...r]) => {
  const low = Number(l) - 1;
  const high = Number(h) - 1;
  return [s[low], s[high]]
    .map(let => let === c ? 1 : 0)
    .reduce((a, b) => a + b)
    === 1;
}

const sol1 = sets
  .map(isValidList1)
  .reduce((a, b) => b ? a + 1 : a, 0);
const sol2 = sets
  .map(isValidList2)
  .reduce((a, b) => b ? a + 1 : a, 0);

console.log(sol1);
console.log(sol2);
