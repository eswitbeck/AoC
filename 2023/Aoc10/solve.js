const { readFileSync } = require('fs');

const fetchFile = (filename) =>
  readFileSync(filename, 'utf-8')
  .trimEnd()

const convertFileToMatrix = (file) =>
  file.split('\n')
  .map(s => s.split(''));

const fileName = 'test_input';

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
  '`': ['n', 's', 'e', 'w']
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

const tracePath = (coord, input) => {
  const q = [[coord, 0, {}]];
  while (q.length) {
    const [c, count, visited] = q.pop();
    const sym = inputAt(input, c);

    const neighbors = applyLookups(c, input)
      .filter(co => isReflexive(c, co, input))
      .filter(co => !visited[coordToString(co)])

    if(!neighbors.length) return { ...visited, [coordToString(c)]: true };

    q.push(...neighbors.map(co =>
      [co, count + 1, { ...visited, [coordToString(c)]: true }]
    ));
  }
}

const trace = tracePath(start, input);

const updatedInput = input
  .map((r, i) => r.map((c, j) => 
    trace[coordToString([j,i])] ? inputAt(input, [j, i]) : '`'
  ));

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

const sumAdjacent = (c, input, visited) => {
  console.log('in', c, inputAt(input, c));
  if (!isInBounds(c)) return [0, visited];
  if (inputAt(input, c) !== '`' || visited[coordToString(c)]) return [0, visited];
  else {
    console.log('passed', c, inputAt(input, c));
    const neighbors = applyLookups(c, input)
      .filter(co => isReflexive(c, co, input))
      .filter(co => !visited[coordToString(co)])

    return neighbors.map(c =>
      sumAdjacent(c, input, { ...visited, [coordToString(c)]: true }))
      .reduce(([a, v1], [b, v2]) => [a + b, { ...v1, ...v2}], [0, {}]);
  }
}

const countInteriors = (coord, input) => {
  const q = [[coord, 0, {}, 0]];
  while (q.length) {
    const [c, count, visited, intCount] = q.pop();
    const sym = inputAt(input, c);

    const neighbors = applyLookups(c, input)
      .filter(co => isReflexive(c, co, input))
      .filter(co => inputAt(input, co) !== '`')
      .filter(co => !visited[coordToString(co)])

    if(!neighbors.length) return intCount;

    q.push(...neighbors.map(co => {
      const [resSum, resVis] = sumAdjacent(orthogonal(c, co), input, {...visited})
      return [
        co,
        count + 1,
        { ...visited, ...resVis, [coordToString(c)]: true },
        intCount + resSum
      ]
    }));
  }
}

updatedInput.forEach(r => console.log(r.join('')));
console.log(countInteriors(start, updatedInput));
