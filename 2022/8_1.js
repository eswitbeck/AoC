class Tree {
  constructor(height, i, j) {
    this.height = height;
    this.i = i;
    this.j = j
  }

  isVisible () {
      for (let y = this.i - 1; y > -1; y--) { //look up
        let compare = forest[y][this.j];
        if (compare.height >= this.height) {
          for (let y = this.i + 1; y < forest.length; y++) { //look down
            let compare = forest[y][this.j];
            if(compare.height >= this.height) {
              for (let x = this.j - 1; x > -1; x--) { //look left
                let compare = forest[this.i][x];
                if(compare.height >= this.height) {
                  for (let x = this.j + 1; x < forest[0].length ; x++) { //look right
                    let compare = forest[this.i][x];
                    if(compare.height >= this.height) return false; //not visible in any direction
                  }
                  return true; //visible from the right
                }
              }
              return true; //visible from the left
            }
          }
          return true; //visible from the bottom
        }
      }
      return true; //visible from the top
  }
}

const {readFileSync} = require('fs');
let input = readFileSync('.\\8_input','utf-8').trimEnd();

let woods = input.split('\n');
let forest = [];

 //fill forest 
for (let i = 0; i < woods.length; i++) {
  let line = woods[i];
  forest[i] = [];
  for (let j = 0; j < line.length; j++) {
    forest[i][j] = new Tree(Number(line[j]), i, j);
  }
}


console.log(
  forest.flat()
    .filter(t => t.isVisible())
    .length
);
