const {readFileSync} = require('fs');

const pair = readFileSync('.\\4_input','utf-8').trimEnd();

let total = pair.split('\n')
  .map(entry => entry.split(','))
  .filter (checkForCommon)
  .length;

console.log(total);

function checkForCommon ([a, b]) {
  let c = a.split('-').map(Number), d = b.split('-').map(Number);
  let condition = ((c[0] <= d[0]) && (c[1] >= d[0])) ||
                  ((d[0] <= c[0]) && (d[1] >= c[0])) ||
                  ((c[0] <= d[1]) && (c[1] >= d[1])) ||
                  ((d[0] <= c[1]) && (d[1] >= c[1]))
  return condition;
}
