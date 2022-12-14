class RopeState {
  constructor (x, y) {
    this.visited = {};
    this.head = {'x': x, 'y': y};
    this.tail = {'x': x, 'y': y}
  }

  move (dir, count) {
    for (let i = 0; i < count; i++) {
      // update head
      switch (dir) {
        case 'U':
          this.head.y++;
          break;
        case 'D': 
          this.head.y--;
          break;
        case 'L':
          this.head.x--;
          break;
        case 'R':
          this.head.x++;
          break;
      }
      // update tail
      if ( //diagonal
        Math.abs(this.head.x - this.tail.x) >= 2 &&
            this.head.y != this.tail.y ||
        Math.abs(this.head.y - this.tail.y) >= 2 &&
            this.head.x != this.tail.x
      ) {
        this.head.x > this.tail.x ? this.tail.x++ : this.tail.x--;
        this.head.y > this.tail.y ? this.tail.y++ : this.tail.y--;
      } else { //linear
        switch (true) {
          case this.head.x - this.tail.x >= 2:
            this.tail.x++;
            break;
          case this.head.x - this.tail.x <= -2:
            this.tail.x--;
            break;
          case this.head.y - this.tail.y >= 2:
            this.tail.y++;
            break;
          case this.head.y - this.tail.y <= -2:
            this.tail.y--;
            break;
        }
      }
      let locationString = `${this.tail.x}, ${this.tail.y}`;
      if (!this.visited[locationString]) this.visited[locationString] = 1;
    }
  }
}

const {readFileSync} = require('fs');
let input = readFileSync('.\\9_input','utf-8').trimEnd();

let rope = new RopeState(0,0)
for (const line of input.split('\n')) {
  [dir, num] = line.split(' ');
  rope.move(dir, Number(num));
}

console.log(Object.keys(rope.visited).length);
