class Tree {
  constructor(height) {
    this.height = height;
    this.counted = false;
  }

  count () {
    this.counted = true;
  }
}

const {readFileSync} = require('fs');
let input = readFileSync('.\\8_input','utf-8').trimEnd();

let woods = input.split('\n');
let forest = [], rowMax = [], colMax = [];
let vis = 0;

 //fill forest 
for (let i = 0; i < woods.length; i++) {
  let line = woods[i];
  forest[i] = [];
  rowMax[i] = -1;
  for (let j = 0; j < line.length; j++) {
    forest[i][j] = new Tree(Number(line[j]));
    colMax[j] = -1;
  }
}

for (let i = 0; i < forest.length; i++) { // L and Top
  let line = forest[i];
  for (let j = 0; j < line.length; j++) {
    if (line[j].height > rowMax[i]) {
      rowMax[i] = line[j].height;
      if (!line[j].counted) {
        vis++;
        line[j].count();
      }
    }
    if (line[j].height > colMax[j]) {
      colMax[j] = line[j].height;
      if (!line[j].counted) {
        vis++;
        line[j].count();
      }
    }
  }
}

//reset maxs
for (let i = forest.length - 1; i > -1; i--) {
  let line = woods[i];
  rowMax[i] = -1;
  for (let j = line.length - 1; j > -1; j--) {
    colMax[j] = -1;
  }
}

for (let i = forest.length - 1; i > -1; i--) { //R and Bottom
  let line = forest[i];
  for (let j = line.length - 1; j > - 1; j--) {
    if (line[j].height > rowMax[i]) {
      rowMax[i] = line[j].height;
      if (!line[j].counted) {
        vis++;
        line[j].count();
      }
    }
    if (line[j].height > colMax[j]) {
      colMax[j] = line[j].height;
      if (!line[j].counted) {
        vis++;
        line[j].count();
      }
    }
  }
}

console.log(vis);
