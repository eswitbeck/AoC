const {readFileSync} = require('fs');
const input = readFileSync('.\\10_input', 'utf-8').trimEnd().split('\n');

let X = 1;
let signal = 0;
let t = 0;

for (const line of input) {
  if (line[0] === 'a') { //addX
    let [_, amount] = line.split(' ').map(Number);
    let count = 2;
    while (count > 0) {
      t++
      signalCheck();
      count--;
    }
    X += amount;
  } else { //noop
    t++;
    signalCheck()
  }

}

console.log(signal);

function signalCheck () {
  if ((t - 20) % 40 === 0) {
    signal += (t * X)
  }
}
