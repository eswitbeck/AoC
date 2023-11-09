const { readFileSync } = require('fs');

const input = readFileSync('input', 'utf-8')
                .trimEnd()
                .split('\n');

const coords = input.map(s => s.matchAll(/(\d*),(\d*) -> (\d*),(\d*)/g))
                    .map(r => {
                      const [[_, w, x, y, z]] = [...r];
                      return ([w, x, y, z]).map(Number);
                    });

const verts_and_horiz = coords.filter(([x1, y1, x2, y2]) => x1 === x2 || y1 === y2)

const add_coords = ([x1, y1, x2, y2], visit_log) => {
  const y_slope = y2 - y1;
  const x_slope = x2 - x1;

  const gcd = (a, b) => {
    let t;
    while (b) {
      t = b;
      b = a % b;
      a = t;
    }
    return Math.abs(a);
  };

  const div = gcd(x_slope, y_slope);
  const slope = [x_slope, y_slope]
          .map(n => n / div);

  const update_log = (i, j, log) => {
    const token = `${i};${j}`;
    if (log[token] === undefined) log[token] = 0;
    log[token]++;
  }

  let i = x1, j = y1;
  while (i !== x2 || j !== y2) {
    update_log(i, j, visit_log);
    i += slope[0];
    j += slope[1];
  }
  update_log(i, j, visit_log);
};

const get_result = (inp) => {
  const visited = {};
  inp.forEach(e => add_coords(e, visited));
  return Object.values(visited)
           .filter(n => n > 1)
           .length;
}
  

console.log(get_result(verts_and_horiz));
console.log(get_result(coords));
