const {readFileSync} = require('fs');
let input = readFileSync('.\\13_input','utf-8')
input += '\n[[2]]\n[[6]]';
input = input
          .split('\n')
          .filter(l => l != '')
          .map(eval);

input = input.sort((a,b) => compare(a,b) ? -1 : 1);
let index2, index6;

for (let i = 0; i < input.length; i++) {
  let j = i + 1;
  if (compare(input[i],[[2]]) == 'same') {
    index2 = j;
    break;
  }
}

for (let i = index2 - 1; i < input.length; i++) {
  let j = i + 1;
  if (compare(input[i],[[6]]) == 'same') {
    index6 = j;
    break;
  }
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

console.log(index2 * index6);
