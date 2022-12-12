const {readFileSync} = require('fs');
const input = readFileSync('.\\12_input', 'utf-8').trimEnd().split('\n');

class Node {
  constructor (val, i, j) {
    this.val = val;
    this.i = i;
    this.j = j;
    this.neighbors;
    this.distance = Infinity;
  }

  checkNeighbors () {
    const connected = (node, neighbor) => neighbor.val - node.val <= 1;
    let nCoords = [[this.i - 1, this.j], [this.i, this.j - 1],
                   [this.i, this.j +1],  [this.i + 1, this.j]]
    this.neighbors = nCoords.filter(([x, y]) => graph[x] && graph[x][y] &&
                                    connected(this, graph[x][y]))
                        .map(([x,y]) => graph[x][y]);
  }
}

let graph = [];
let unvisited = [];

//convert graph
for (let i = 0; i < input.length; i++) {
  let line = input[i];
  graph[i] = [];
  for (let j = 0; j < line.length; j++) {
    let loc = line[j];
    graph[i][j] = new Node (loc.charCodeAt() - 96, i, j);
    if (loc == 'S') {
      start = graph[i][j];
      start.distance = 0;
      start.val = 1;
    } else if (loc == 'E') {
      end = graph[i][j];
      end.val = 26;
    }
    unvisited.push(graph[i][j]);
  }
}

//populate nodes
for (const n of graph.flat()) n.checkNeighbors();

//Dijkstra
function traverse (node) {
  let unvis = node.neighbors.filter(n => unvisited.includes(n));
  for (const neigh of unvis) {
    neigh.distance = Math.min(neigh.distance, node.distance + 1)
  }
  unvisited.splice(unvisited.indexOf(node),1)
    if (!unvisited.includes(end) ||
        unvisited
          .map(n => n.distance)
          .reduce((a,b) => Math.min(a,b)) == Infinity) {
      return end.distance
    } else {
      let least = unvisited.sort((a,b) => a.distance - b.distance)[0];
      return traverse(least);
    }
}

console.log(traverse(start));
