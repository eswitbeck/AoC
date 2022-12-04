const {readFileSync} = require('fs');

const pair = readFileSync('.\\4_input','utf-8').trimEnd();

let total = pair.split('\n')
  .map(entry => entry.split(',')
    .map(e => e.split('-').map(Number)))
  .filter (checkForCommon)
  .length;

console.log(total);

function checkForCommon ([[c0,c1],[d0,d1]]) {
  return ((c0 <= d0) && (c1 >= d0)) ||
         ((d0 <= c0) && (d1 >= c0)) ||
         ((c0 <= d1) && (c1 >= d1)) ||
         ((d0 <= c1) && (d1 >= c1))
}
