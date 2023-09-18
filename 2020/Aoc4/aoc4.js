const { readFileSync } = require('fs');

const input = readFileSync('input', 'utf-8')
  .trimEnd()
  .split('\n\n')
  .map(b => {
    const arr = b.split(/\n| /);
    return arr.map(pair => {
      const [_, key, value, ...rest] = pair.match(/(.{3}):(.*)/);
      return [key, value];
    })
  });

const bundleResult = (arr) => {
  const output = {};
  output.array = arr;
  output.result = {};
  const validate = ([key, value]) => {
    switch (key) {
      case 'pid':
        output.result.pid = value.match(/\d{9}/) !== null && value.length === 9;
        break;
      case 'hgt':
        const regex = /(\d+)(cm|in)/;
        if (!value.match(regex)) output.result.hgt = false;
        else {
          const [_, v, unit, ...rest] = value.match(regex);
          if (unit === 'cm') {
            const vl = Number(v);
            output.result.hgt = vl >= 150 && vl <= 193;
          } else if (unit === 'in') {
            const vl = Number(v);
            output.result.hgt = vl >= 59 && vl <= 76;
          }
        }
        break;
      case 'ecl':
        output.result.ecl = value.match(/(amb|blu|brn|gry|grn|hzl|oth)/) !== null;
        break;
      case 'eyr':
        value = Number(value);
        output.result.eyr = value >= 2020 && value <= 2030;
        break;
      case 'byr':
        value = Number(value);
        output.result.byr = value >= 1920 && value <= 2002;
        break;
      case 'iyr':
        value = Number(value);
        output.result.iyr = value >= 2010 && value <= 2020;
        break;
      case 'hcl':
        output.result.hcl = value.match(/#[0-9a-f]{6}/) !== null && value.length === 7;
        break;
      case 'cid':
        output.result.cid = true;
        break;
    }
  }
  arr.forEach(validate);
  output.final = output.result.pid &&
    output.result.hgt &&
    output.result.eyr &&
    output.result.byr &&
    output.result.iyr &&
    output.result.hcl &&
    output.result.ecl 
  return output;
};

const evaledInput = input.map(bundleResult);

evaledInput.map(v => { console.log(v); });

console.log(evaledInput.map(v => v.final)
  .filter(x => x)
  .length);
