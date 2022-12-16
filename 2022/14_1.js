const {readFileSync} = require('fs');
const input = readFileSync('.\\14_input','utf-8').trimEnd();

let maxY = -Infinity;

class Rock {
  constructor (line) {
    this.coordinates = {};
    line = line
      .split(' -> ')
      .map(c => c.split(',')
        .map(Number));
    for (let i = 1; i < line.length; i++) {
      let [sx, sy] = line[i - 1], [ex, ey] = line[i];
      maxY = sy > maxY ? sy : maxY;
      maxY = ey > maxY ? ey : maxY;
      if (sx === ex) { //vertical line
        if (sy > ey) {
          for (let j = sy ; j >= ey; j--) {
            this.coordinates[convertCoords(sx, j)] = true;
          }
        } else {
          for (let j = sy; j <= ey; j++) {
            this.coordinates[convertCoords(sx, j)] = true;
          }
        }
      } else { //horizontal line
        if (sx > ex) {
          for (let j = sx; j >= ex; j--) {
            this.coordinates[convertCoords(j, sy)] = true;
          }
        } else {
          for (let j = sx; j <= ex; j++) {
            this.coordinates[convertCoords(j, sy)] = true;
          }
        }
      }
    }
  }
}

class SandGrain {
  constructor () {
    this.x = 500;
    this.y = 0;
  }

  move (cave) {
    const restingCoords = [[this.x - 1, this.y + 1],
                          [this.x,     this.y + 1],
                          [this.x + 1, this.y + 1]]
                            .map(([x,y]) => convertCoords(x, y));
    const cont = c => cave.coordinates[c];
    if (this.y > maxY) { //fall forever
      cave.full = true;
    } else if (!cont(restingCoords[1])) { //down
      this.y++;
      this.move(cave);
    } else if (!cont(restingCoords[0])) { //left
      this.x--;
      this.y++;
      this.move(cave);
    } else if (!cont(restingCoords[2])) { //right
      this.x++;
      this.y++;
      this.move(cave);
    }
  }
}

class Cave {
  constructor (caveData) {
    this.coordinates = {};
    for (const line of caveData.split('\n')) {
      let r = new Rock(line);
      Object.assign(this.coordinates, r.coordinates);
    }
    this.full = false;
    this.sandCount = 0;
  }

  dropSand() {
    let grain = new SandGrain;
    grain.move(this);
    let grainFinalCoords = convertCoords(grain.x, grain.y);
    this.coordinates[grainFinalCoords] = true;
  }
  cascade() {
    while(!cave.full) {
      this.dropSand();
      this.sandCount++;
    }
  }
}

let cave = new Cave (input);
cave.cascade();

console.log(cave.sandCount - 1);

function convertCoords (x,y) {return `${x}.${y}`;}

