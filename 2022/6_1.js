const {readFileSync} = require('fs');

const input = readFileSync('.\\6_input','utf-8').trimEnd();

for (i = 4; i < input.length; i++) {
  let selection = input.slice(i - 4, i);
  console.log(selection.slice(2,4));
  if (!selection.slice(1,4).includes(selection[0]) &&
     !selection.slice(2,4).includes(selection[1]) &&
      selection[2] !== selection[3]) {
    console.log(i);
    break;
  }
};
