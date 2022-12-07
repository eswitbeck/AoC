class Dir {
  constructor() {
    this.storage = {};
  }
  addFile ([size, name]) {
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
  lsRecurse() { //return flattened tree
    let wrapper = (file) => { 
      if (typeof file == 'number') { 
        return [file];
      } else {
        return [file].concat(
          Object.values(file.storage).map(wrapper).flat());
      }
    }
    return wrapper(this);
  }
  smallestDir() {
    let free = 70000000 - root.sumContents();
    let needed = 30000000 - free;
    return this.lsRecurse()
      .filter(f => typeof f != 'number')
      .map(f => f.sumContents())
      .filter(f => f >= needed)
      .reduce((a,b) => Math.min(a,b), Infinity)
  }
}

function populateDir (input, directory) {
  let dest = directory;
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

const {readFileSync} = require('fs');
const input = readFileSync('.\\7_input','utf-8');
let commands = input.split('\$ ').slice(2);

let root = new Dir();
populateDir(commands, root);
console.log(root.smallestDir());
