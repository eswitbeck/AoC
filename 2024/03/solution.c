#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "../shared/FileUtils.h"

typedef struct Node {
  char *data;
  struct Node *next;
} Node;

char* add2str(int x, int y) {
  char *buf = malloc(sizeof(char) * 8); // leak all over the place, just make
                                        // sure there's space
  sprintf(buf, "%d,%d", x, y);
  return buf;
}

int* str2add(char *str) {
  int *coord = malloc(sizeof(int) * 2);
  sscanf(str, "%d,%d", &coord[0], &coord[1]);

  return coord;
}

int char2n (char c) {
  if (c >= '0' && c <= '9') {
    return c - '0'; //maps to 0-9
  } else if (c >= 'a' && c <= 'z') {
    return c - 'a' + 10; // 10-35
  } else  if (c >= 'A' && c <= 'Z') {
    return c - 'A' + 36; // 36-61
  } else {
    perror("invalid char\n");
    exit(1);
  }
}

int main () {
  size_t length;
  char *input = read_file("./input", &length);
  if (!input) {
    perror("DIDN'T READ FILE YOU BOZO\n");
    exit(1);
  }

  Node *map[62] = { NULL };
  // 0 - 9 char - 48
  // a - z char - 97 + 10
  // A - Z char - 65 + 36

  size_t max_x = 0, max_y = 0;
  char **lines = split_string(input, "\n", &max_y);

  // parse all chars into map of lists
  for (int y = 0; y < max_y; y++) {
    char *line = lines[y];

    if (!max_x) max_x = strlen(line);

    for (int x = 0; x < max_x; x++) {
      char c = line[x];

      if ('.' == c) continue;

      int key = char2n(c);

      char *add = add2str(x, y);

      Node *n = malloc(sizeof(Node));
      n->next = NULL;
      n->data = add;

      Node *head = map[key];

      if(!head) {
        map[key] = n;
      } else {
        while (head->next) {
          head = head->next;
        }
        head->next = n;
      }
    }
  }

  bool antinodes[max_x * max_y];
  for (int i = 0; i < max_x * max_y; i++) {
    antinodes[i] = false;
  }

  for (int i = 0; i < 62; i++) {
    Node *head = map[i];

    while (head) {
      Node *tail = head->next;

      while (tail) {
        char *to_add_s = tail->data;
        char *from_add_s = head->data;

        int *to_add = str2add(to_add_s);
        int *from_add = str2add(from_add_s);

        int x_diff = to_add[0] - from_add[0];
        int y_diff = to_add[1] - from_add[1];

        int antinode1[2] = { from_add[0] - x_diff, from_add[1] - y_diff };
        int antinode2[2] = { to_add[0] + x_diff, to_add[1] + y_diff };

        if ((antinode1[0] >= 0 && antinode1[0] < max_x) &&
           (antinode1[1] >= 0 && antinode1[1] < max_y)) {
          int addr = antinode1[1] * max_x + antinode1[0];
          antinodes[addr] = true;
        }
        if ((antinode2[0] >= 0 && antinode2[0] < max_x) &&
           (antinode2[1] >= 0 && antinode2[1] < max_y)) {
          int addr = antinode2[1] * max_x + antinode2[0];
          antinodes[addr] = true;
        }

        tail = tail->next;
      }

      head = head->next;
    }
  }

  int total = 0;
  for (int i = 0; i < max_x * max_y; i++) {
    if (antinodes[i]) total++;
  }

  printf("num_nodes: %d\n", total);

  // need to intelligently free ... just leaking all over the place


  free(input);
}
