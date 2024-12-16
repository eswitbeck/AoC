#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../shared/FileUtils.h"

void add_vec(
  int *origin,
  int *dir,
  int *res
) {
  res[0] = origin[0] + dir[0];
  res[1] = origin[1] + dir[1];
}

void sub_vec(
  int *origin,
  int *dir,
  int *res
) {
  res[0] = origin[0] - dir[0];
  res[1] = origin[1] - dir[1];
}

int get_add(int *vec, int max_x) {
  return vec[1] * max_x + vec[0];
}

char get_adj(
  int *origin,
  int *vec,
  char *map,
  int max_x
) {
  int tmp[2] = { 0, 0 };
  add_vec(origin, vec, tmp);
  return map[get_add(tmp, max_x)];
}

int move_obj(
  char dir,
  int *pos,
  char *map,
  int max_x
) {
  int vec[2] = { 0, 0 };
  int res[2] = { 0, 0 };

  // for depth
  int amp[2] = { 0, 0 };

  switch(dir) {
    case '<': 
      vec[0] = -1;
      vec[1] = 0;
      break;
    case '>': 
      vec[0] = 1;
      vec[1] = 0;
      break;
    case '^': 
      vec[0] = 0;
      vec[1] = -1;
      break;
    case 'v': 
      vec[0] = 0;
      vec[1] = 1;
      break;
  }

  add_vec(amp, vec, amp);

  int depth = 0;
  char adj = '\0';

  while ('.' != adj && '#' != adj) {
    adj = get_adj(pos, amp, map, max_x);
    depth++;
    add_vec(amp, vec, amp);
  }

  if ('#' == adj) {
    // don't walk through walls
    return -1;
  }

  for (int i = depth; i > 1; i--) {
    // move all boxes
    sub_vec(amp, vec, amp);
    int tmp_vec[2] = { 0, 0 };
    add_vec(pos, amp, tmp_vec);
    int add = get_add(tmp_vec, max_x);

    map[add] = 'O';
  }

  // move robot
  int tmp_vec[2] = { 0, 0 };
  add_vec(pos, vec, tmp_vec);
  map[get_add(tmp_vec, max_x)] = '@';

  // replace robot
  map[get_add(pos, max_x)] = '.';

  // readdr robot
  add_vec(pos, vec, pos);

  return -1;
}

int main() {
  size_t num_moves = 0;
  char *direction_input = read_file("./input_path", &num_moves);
  if (!direction_input) {
    perror("DIDN'T READ DIR FILE YOU BOZO\n");
    exit(1);
  }

  size_t temp_len = 0;
  char *map = read_file("./input", &temp_len);
  if (!map) {
    perror("DIDN'T READ MAP YOU BOZO\n");
    exit(1);
  }

  size_t y_len = 0;
  char **lines = split_string(map, "\n", &y_len);
  size_t x_len = strlen(lines[0]);

  char coords[y_len * x_len];

  for (int i = 0; i < y_len * x_len; i++) {
    coords[i] = '\0';
  }

  int robot_pos[2] = { -1, -1 };

  for (int y = 0; y < y_len; y++) {
    char *line = lines[y];

    for (int x = 0; x < x_len; x++) {
      char c = line[x];

      if ('@' == c) {
        robot_pos[0] = x;
        robot_pos[1] = y;
      }

      coords[y * x_len + x] = c;
    }
  }

  // wee!
  for (int i = 0; i < num_moves; i++) {
    char dir = direction_input[i];
    move_obj(dir, robot_pos, coords, x_len);
  }

  size_t total = 0;

  for (int i = 0; i < x_len * y_len; i++) {
    char c = coords[i];
    if ('O' == c) {
      int y = i / x_len;
      int x = i - (y * x_len);

      total += (y * 100 + x);
    }
  }
  printf("total: %zu\n", total);

  return 0;
}
