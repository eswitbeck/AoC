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
    function updateHead (head) {
      switch (dir) {
        case 'U':
          head['y']++;
          break;
        case 'D': 
          head['y']--;
          break;
        case 'L':
          head['x']--;
          break;
        case 'R':
          head['x']++;
          break;
        }
      }
    function updateKnot (head, tail, knotCount, num, visited) {
      if ( //diagonal
        Math.abs(head['x'] - tail['x']) >= 2 &&
            head['y'] != tail['y'] ||
        Math.abs(head['y'] - tail['y']) >= 2 &&
            head['x'] != tail['x']
      ) {
        head['x'] > tail['x'] ? tail['x']++ : tail['x']--;
        head['y'] > tail['y'] ? tail['y']++ : tail['y']--;
      } else { //linear
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
      if(num == knotCount - 1) {
        if (!visited[locationString]) visited[locationString] = 1;
      } 
    }

    for (let i = 0; i < count; i++) {
      updateHead(this.head);
      for (const kn in this.tail){
        if (kn == 0) {
          updateKnot(this.head, this.tail[kn], this.tail.length, kn, this.visited)
        } else {
          updateKnot(this.tail[kn - 1], this.tail[kn], this.tail.length, kn, this.visited);
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
