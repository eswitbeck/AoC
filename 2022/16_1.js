class Node {
  constructor(name, flow, connections) {
    this.name = name;
    this.flow = Number(flow);
    this.connections = {};
    for (const c of connections.split(', ')) {
      this.connections[c] = true;
    }
    this.path = [];
    this.minutes = Infinity;
    this.aggregateFlow = -Infinity;
  }

  getChildren() {
    let children = [];
    for (const c of Object.keys(this.connections)) {
      children.push(graph[c])
    }
    return children;
  }
  opens() {
    return this.flow !== 0;
  }
}

const {readFileSync} = require('fs');
const input = readFileSync('.\\16_input', 'utf-8').trimEnd();

let regex = /Valve (.{2}) has flow rate=(\d{1,2}); tunnels* leads* to valves* (.+)/g; 
const graph = {};
const unvisited = {};
const visited = {};

//populate graph
for (const line of input.split('\n')) {
  let [[_,name, flow, connections]] = [...line.matchAll(regex)];

  graph[name] = new Node(name, 0, connections);

  //opening a valve is also a node
  if (flow !== '0') {
    let open = name + '-open';
    //the only access point is the closed-version node
    graph[name].connections[open] = true;
    graph[open] = new Node(open, flow, connections);
  }
}

graph.AA.minutes = 0;
graph.AA.aggregateFlow = 0;
unvisited.AA = true;

//traverse graph 
function traverse (node) {
  //All visited OR minimum minutes of unvisited is Infinity (no connections
    //between them and start); finished
  if(Object.keys(unvisited).filter(n => unvisited[n]).length === 0 ||
     Object.keys(unvisited).map(n => graph[n].minutes)
        .reduce((a,b) => Math.min(a,b)) === Infinity) {
    return Object.keys(visited).map(n => graph[n].aggregateFlow)
            .reduce((a,b) => Math.max(a,b));
  }
  if (node.minutes < 30) {
    const children = node.getChildren();
    if (children.length !== 0) for (const child of children) {
      //child is not an '-open' node already visited in this path
      if (!(child.opens() && node.path.includes(child.name))) {
        let possibleVal = node.aggregateFlow +
          (30 - (node.minutes + 1)) * child.flow;
        if (possibleVal > child.aggregateFlow) {
          child.aggregateFlow = possibleVal;
          child.minutes = node.minutes + 1;
          child.path = [...node.path];
          child.path.push(node.name);
          unvisited[child.name] = true;
        }
      }
    }
  }
  visited[node.name] = true;
  unvisited[node.name] = false;
  let unvis = Object.keys(unvisited)
                .filter(n => unvisited[n]);
  let minimumMinutes = unvis.map(n => graph[n].minutes)
                          .reduce((a,b) => Math.min(a,b), Infinity);
  let next = unvis.filter(n => graph[n].minutes === minimumMinutes)                            
              .sort((a,b) => graph[a].aggregateFlow - graph[b].aggregateFlow)
              [0];
  return traverse(graph[next]);
} 

console.log(traverse(graph.AA));

console.log(Object.keys(visited)
            .sort((a,b) => graph[b].aggregateFlow - graph[a].aggregateFlow)
            .map(n => graph[n])
              [0].path);
