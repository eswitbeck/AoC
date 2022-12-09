class RopeState {
  constructor (x, y, knots) {
    this.visited = {};
    this.head = {'x': x, 'y': y};
    this.tail = [];
    for (let i = 0; i < knots; i++) {
      this.tail[i] = {'x': x, 'y': y}
    }
  }

  move (dir, count) {
    function updateHead (main) {
      switch (dir) {
        case 'U':
          main.head['y']++;
          break;
        case 'D': 
          main.head['y']--;
          break;
        case 'L':
          main.head['x']--;
          break;
        case 'R':
          main.head['x']++;
          break;
        }
      }
    function updateKnot (head, tail, main, num) {
      if (
        Math.abs(head['x'] - tail['x']) >= 2 &&
            head['y'] != tail['y'] ||
        Math.abs(head['y'] - tail['y']) >= 2 &&
            head['x'] != tail['x']
      ) {
        head['x'] > tail['x'] ? tail['x']++ : tail['x']--;
        head['y'] > tail['y'] ? tail['y']++ : tail['y']--;
      } else { 
        switch (true) {
          case head['x'] - tail['x'] >= 2:
            tail['x']++;
            break;
          case head['x'] - tail['x'] <= -2:
            tail['x']--;
            break;
          case head['y'] - tail['y'] >= 2:
            tail['y']++;
            break;
          case head['y'] - tail['y'] <= -2:
            tail['y']--;
            break;
        }
      }
      let locationString = tail['x'].toString() + "." + tail['y'].toString();
      if(num == main.tail.length - 1) {
        if (!main.visited[locationString]) main.visited[locationString] = 1;
      } 
    }

    for (let i = 0; i < count; i++) {
      updateHead(this);
      for (const kn in this.tail){
        if (kn == 0) {
          updateKnot(this.head, this.tail[kn], this, kn)
        } else {
          updateKnot(this.tail[kn - 1], this.tail[kn], this, kn);
        }
      }
    }
  }
}

const {readFileSync} = require('fs');
let input = readFileSync('.\\9_input','utf-8').trimEnd();

let rope = new RopeState(0,0,9)
for (const line of input.split('\n')) {
  [dir, num] = line.split(' ');
  rope.move(dir, Number(num));
}

console.log(Object.keys(rope.visited).length);
