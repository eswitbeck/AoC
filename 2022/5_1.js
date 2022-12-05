const {readFileSync} = require('fs');

let input = readFileSync('.\\5_input','utf-8').trimEnd();
input = input.split('\n');
let start = input.slice(0,8);
let act = input.slice(10);

let match = /move (\d{1,2}) from (\d) to (\d)/g
let startMatch = /(   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\]) (   |\[.{1}\])/g

const startObj = [];
for (let i = 0; i < 9; i++) {
  startObj.push([]);
}

start.map( e => e.matchAll(startMatch) )
  .map(match => [...match])
  .map(e => assignToStart(e, startObj));

act.map( e => e.matchAll(match) )
  .map(match => [...match])
  .map(e => pullNumber(e).map(Number))
  .map(e => enactMove(e, startObj))

console.log(
  startObj.map(stack => stack[stack.length - 1])
  .reduce ((a,b) => a += b, '')
)


function pullNumber ([matched]) {
  let out = [...matched];
  return [out[1], out[2], out[3]];
}

function assignToStart ([matched], obj) {
  let out = [...matched].slice(1,10)
  for (let i = 0; i < out.length; i++) {
    if (out[i] !== '   ') {
      obj[i].unshift(out[i][1]);
    }
  }
}

function enactMove ([count, from, to], obj) {
  for (let i = 0; i < count; i++) {
    obj[to - 1].push(obj[from - 1].pop());
  }
}
