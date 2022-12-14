class Tree {
  constructor(height, i, j) {
    this.height = height;
    this.i = i;
    this.j = j
  }
  
  findScenicScore () {
    let up = 0, down = 0, left = 0, right = 0;
    for (let y = this.i - 1; y > -1; y--) {
      up++
      let compare = forest[y][this.j];
      if (compare.height >= this.height) break;
    }
    for (let y = this.i + 1; y < forest.length; y++) {
      down++
      let compare = forest[y][this.j];
      if (compare.height >= this.height) break;
    }
    for (let x = this.j - 1; x > -1; x--) {
      left++;
      let compare = forest[this.i][x];
      if (compare.height >= this.height) break;
    }
    for (let x = this.j + 1; x < forest[0].length ; x++) { 
      right++;
      let compare = forest[this.i][x];
      if (compare.height >= this.height) break;
    }
    return up * down * left * right;
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
    .map(t => t.findScenicScore())
    .reduce((a,b) => Math.max(a,b))
);
