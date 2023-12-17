const { readFileSync } = require('fs');

const fetchFile = (filename) =>
  readFileSync(filename, 'utf-8')
  .trimEnd()

const convertFileToMatrix = (file) =>
  file.split('\n')
  .map(s => s.split(''));

const fileName = 'input';

const input = convertFileToMatrix(fetchFile(fileName));

const directionLookup = {
  'n': [0, -1],
  's': [0, 1],
  'e': [1, 0],
  'w': [-1, 0]
}

const symbolLookup = {
  '|': ['n', 's'],
  '-': ['e', 'w'],
  'L': ['n', 'e'],
  'J': ['n', 'w'],
  '7': ['s', 'w'],
  'F': ['s', 'e'],
  '.': [],
  'S': ['n', 's', 'e', 'w'],
  '*': ['n', 's', 'e', 'w'],
  '>': ['e'],
  '<': ['w'],
  'v': ['s'],
  '^': ['n']
}

const addVec = ([x1, y1], [x2, y2]) => [x1 + x2, y1 + y2];

const isInBounds = ([x, y]) => 
  x >= 0 && x < input[0].length &&
  y >= 0 && y < input.length;

const coordToString = ([x, y]) => `${x};${y}`;

const start =
  input
    .map((r, j) => 
      r.map((s, i) => s === 'S' ? [i, j] : -1))
    .flat()
    .filter(s => s !== -1)[0]

const inputAt = (input, [x, y]) => input[y][x];

const applyLookups = (coord, input) => {
  return symbolLookup[inputAt(input, coord)]
    .map(dir => directionLookup[dir])
    .map(v => addVec(v, coord))
    .filter(isInBounds);
}

const isReflexive = (from, to, input) => {
  const eq = ([x1, y1], [x2, y2]) => x1 === x2 && y1 === y2;
  const toNeighbors = applyLookups(to, input);
  return toNeighbors.some(c => eq(from, c));
}

const getDir = (c1, c2) => {
  const [x1, y1] = c1;
  const [x2, y2] = c2;
  const x = x2 - x1;
  const y = y2 - y1;

  if (x === 1) {
    return '>';
  } else if (x === -1) {
    return '<';
  } else if (y === 1) {
    return 'v';
  } else if (y === -1) {
    return '^';
  }
}

const tracePath = (coord, input) => {
  console.log('tracing...');
  const results = [];
  const q = [[coord, 0, {}]];
  while (q.length) {
    const [c, count, visited] = q.pop();
    const sym = inputAt(input, c);

    const neighbors = applyLookups(c, input)
      .filter(co => isReflexive(c, co, input))
      .filter(co => !visited[coordToString(co)])

    if(!neighbors.length) {
      const dir = getDir(start, c)
      results.push({ ...visited, [coordToString(c)]: dir });
    }

    q.push(...neighbors.map(co => {
      const dir = getDir(c, co);
      return [co, count + 1, { ...visited, [coordToString(c)]: dir }]
    }));
  }
  console.log('traced');
  return results;
}

const trace = tracePath(start, input);

const updateInput = (trace) => 
  input
  .map((r, i) => r.map((c, j) => 
    trace[coordToString([j,i])] ? trace[coordToString([j,i])] : '*'
  ));

const updates = trace.map(updateInput);

const orthogonal = (start, end) => {
  const [x1, y1] = start;
  const [x2, y2] = end;
  const x = x2 - x1;
  const y = y2 - y1;
  
  const move = (coord, dir) => {
    const r = addVec(coord, directionLookup[dir]);
    return r;
  }

  if (x === 1) {
    return move(start, 's');
  } else if (x === -1) {
    return move(start, 'n');
  } else if (y === 1) {
    return move(start, 'w');
  } else if (y === -1) {
    return move(start, 'e');
  }
}

const inputLog = input => {
  input.forEach(r => console.log(r.join('')));
  console.log();
}

const visToFinal = (vis, input) => {
  return input.map((r, i) => 
    r.map((c, j) => 
      vis[coordToString([j,i])] ? '$' : c
  ))
}

const sumAdjacent = (c, input, visited) => {
  if (visited[coordToString(c)] ||
      ! isInBounds(c) ||
      inputAt(input, c) !== '*') {
    return [0, visited];
  }

  const q = [c];
  let total = 0;
  while (q.length) {
    const coord = q.pop();
    const neighbors = applyLookups(coord, input)
      .filter(co => inputAt(input, co) === '*')
      .filter(co => !visited[coordToString(co)])

    visited[coordToString(coord)] = true;
    q.push(...neighbors);
  }
  return [total, visited];
}

const countInteriors = (coord, input) => {
  console.log('counting interiors...');
  const results = [];
  const q = [[coord, 0, {}, 0, {}]];
  while (q.length) {
    const [c, count, visited, intCount, intVisited] = q.pop();
//    inputLog(visToFinal(intVisited, input));

    const neighbors = applyLookups(c, input)
      .filter(co => inputAt(input, co) !== '*')
      .filter(co => !visited[coordToString(co)])


    if(!neighbors.length) results.push([count, intCount, intVisited]);

    else {
      q.push(...neighbors.map(co => {
        const [resSum, resVis] = sumAdjacent(orthogonal(c, co), input, intVisited);
        visited[coordToString(c)] = true;
        return [
          co,
          count + 1,
          visited,
          0,
          resVis
        ]
      }));
    }
  }
  console.log('counted');
  return results[0]; // only one now
}

const res = updates.map( u => countInteriors(start, u));

console.log(
res.map(([c, i, v], j) => [v, visToFinal(v, updates[j])])
  .map(([v, i]) => {console.log(Object.keys(v).length); return i; })
  .map((f, j) => { inputLog(f, updates[j]); return f })
  .map(i => { const flat = i.flat(2);
    return [flat.filter(x => x === '*').length,
            flat.filter(x => x === '$').length]
  }))
