const {readFileSync} = require('fs');

let input = readFileSync('.\\5_input','utf-8').trimEnd();
input = input.split('\n');
let start = input.slice(0,8);
let act = input.slice(10);

const startObj = [];
for (let i = 0; i < 9; i++) {
  startObj.push([]);
}

start.map( e => e.match(/(    |\[.\] )/g))
  .map(e => assignToStart(e, startObj));

act.map( e => e.match(/ \d{1,2}/g ))
  .map(e => pullNumber(e).map(Number))
  .map(e => enactMove(e, startObj))

console.log(
  startObj.map(stack => stack[stack.length - 1])
  .join('')
)


function pullNumber (out) {
  return [out[0], out[1], out[2]];
}

function assignToStart (out, obj) {
  for (let i = 0; i < out.length; i++) {
    if (out[i] !== '    ') {
      obj[i].unshift(out[i][1]);
    }
  }
}

function enactMove ([count, from, to], obj) {
  for (let i = 0; i < count; i++) {
    obj[to - 1].push(obj[from - 1].pop());
  }
}
