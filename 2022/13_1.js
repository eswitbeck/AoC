const {readFileSync} = require('fs');
const input = readFileSync('.\\13_input','utf-8').trimEnd().split('\n\n');

let total = 0;
for(let i = 0; i < input.length; i++) {
  let j = i + 1;
  let [a, b] = input[i].split('\n').map(eval);
  if (compare(a, b)) total += j;
}

function compare(a, b) {
  const catchSame = (check, alt) => (check != 'same') ? check : alt;
  if (a.length === 0 && b.length === 0) return 'same';
  if (a.length === 0) return true;
  if (b.length === 0) return false;
  if (typeof a === 'number') {
    if (typeof b === 'number') return (a == b) ? 'same': a < b;
    else return compare ([a], b); //a num, b arr
  }
  if (typeof b === 'number') { //a arr, b num
    return compare (a, [b]);
  } else { //a arr, b arr
    return catchSame(compare (a[0], b[0]),
                     compare(a.slice(1), b.slice(1))); 
  }
}

console.log(total);
