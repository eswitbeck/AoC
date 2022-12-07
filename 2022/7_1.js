const {readFileSync} = require('fs');

const input = readFileSync('.\\7_input','utf-8');

let commands = input.split('\$ ').slice(2);

class Dir {
  constructor() {
    this.storage = {};
  }
  addFile ([size,name]) {
    if(size == 'dir') this.storage[name] = new Dir();
    else this.storage[name] = Number(size);
  }
  sumContents () {
    return Object.values(this.storage)
      .map( v => {
        if (typeof v == 'number') return v;
        else return v.sumContents();
      })
      .reduce((a,b) => a + b, 0);
  }
  funkySum () {
    let sum = 0;
    Object.values(this.storage)
      .map( v => {
        if (typeof v == 'number') sum += 0;
        else if (v.sumContents() <= 100000) {
          sum += (v.sumContents() + v.funkySum());
        } else {
          sum += v.funkySum()
        };
      });
    return sum;
  }
}



let root = new Dir();

function populateDir (input) {
  let dest = root;
  let history = [];
  for (command of input) {

    let commands = command.split('\n');
    commands.pop();

    if (commands[0][0] == 'l') { //ls
      commands.slice(1).map(f => parseFile(f, dest));

    } else { //cd
      let [_, target] = commands[0].split(' ');

      if (target == '..') {
        dest = history.pop();

      } else {
        history.push(dest);
        dest = dest.storage[target];
      }
    }
  }
}

function parseFile (file, destination) {
  let filePair = file.split(' ');
  destination.addFile(filePair);
}

populateDir(commands);
console.log(root.funkySum());
