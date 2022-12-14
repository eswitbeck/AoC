const {readFileSync} = require('fs');

const input = readFileSync('.\\6_input','utf-8').trimEnd();

for (i = 14; i < input.length; i++) {
  let selection = input.slice(i - 14, i);
  if (allUnique(selection)) {
    console.log(i);
    break;
  }
}

function allUnique (str) {
  if (str.length === 0) return true;
  if (str.slice(1,str.length).includes(str[0])) return false;
  return allUnique (str.slice(1,str.length));
}
