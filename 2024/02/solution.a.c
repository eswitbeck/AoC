#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "../shared/FileUtils.h"

int main () {
  size_t length;
  char *input = read_file("./input", &length);
  if (!input) {
    perror("DIDN'T READ FILE YOU BOZO\n");
    exit(1);
  }

  char **levels = split_string(input, "\n", &length);

  int safe_count = 0;

  for (size_t i = 0; i < length; i++) {
    size_t gradation_count;
    char** grades = split_string(levels[i], " ", &gradation_count);

    bool safe = true;
    int increasing = 0;
    for (size_t j = 0; j < gradation_count - 1; j++) {
      int first, second;

      sscanf(grades[j], "%d", &first);
      sscanf(grades[j + 1], "%d", &second);

      int inc = second - first;

      if (!increasing) {
        increasing = inc;
      } else {
        if ((inc > 0 && increasing < 0) ||
            (inc < 0 && increasing > 0)
        ) {
          safe = false;
        }
      }

      if (abs(inc) > 3 ||
          abs(inc) < 1) {
        safe = false;
      }
    }

    if (safe) {
      safe_count++;
    }

    // in an ideal world have some intelligent pooling so I can do this at the
    // end

    for (size_t i; i < gradation_count; i++) {
      free(grades[i]);
    }
    free(grades);
  }

  printf("Safe count: %d\n", safe_count);

  for (size_t i; i < length; i++) {
    free(levels[i]);
  }
  free(levels);

  free(input);
}
