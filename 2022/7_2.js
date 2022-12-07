const {readFileSync} = require('fs');

const input = readFileSync('.\\7_input','utf-8');

let commands = input.split('\$ ');
commands.shift();
commands.shift();

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
      .reduce((a,b) => a + b,0);
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
  smallestDir (free) {
    return Object.values(this.storage) 
      .filter( v => typeof v !== 'number' )
      .map(v => {listOut.push(v.sumContents()); v.smallestDir(free)});
  }
}



let root = new Dir();

function populateDir (contents) {
  let dest = root;
  let history = [];
  for (command of contents) {

    let files = command.split('\n');
    files.pop();

    if (files[0][0] == 'l') {
      files.slice(1).map(f => parseFile(f, dest));

    } else if (files[0][0] == 'c') {
      let [_, target] = files[0].split(' ');

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

let listOut = [];

populateDir(commands);
root.smallestDir(70000000 - root.sumContents);
let free = 70000000 - root.sumContents();
let needed = 30000000 - free;
console.log(
  listOut.filter ( n => n >= needed )
  .reduce((a,b) => Math.min(a,b), Infinity)
);
