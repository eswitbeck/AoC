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
  lsRecurse() { // return flattened deep list of only directory sizes
    let wrapper = (file) => {
      if (typeof file != 'number') {
        return [file.sumContents()].concat(
          Object.values(file.storage).map(wrapper).flat());
      } else return [];
    }
    return wrapper(this);
  }
  funkySum () {
    return this.lsRecurse()
      .filter(f => f <= 100000)
      .reduce((a,b) => a + b, 0)
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
