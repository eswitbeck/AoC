#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "../shared/FileUtils.h"

int comparator(const void *a, const void *b) {
  return *(int *)a - *(int *)b;
}

int main() {
  size_t length;
  char *input = read_file("./input", &length);
  if (!input) {
    perror("DIDN'T READ FILE YOU BOZO\n");
    exit(1);
  }

  length = 0; // ... probably should use this
  char **pair_strs = split_string(input, "\n", &length);

  int pairs[2][length];

  for (size_t i = 0; i < length; i++) {
    sscanf(pair_strs[i], "%d   %d", &pairs[0][i], &pairs[1][i]);
  }

  qsort(pairs[0], length, sizeof(int), comparator);
  qsort(pairs[1], length, sizeof(int), comparator);

  size_t sum = 0;

  for (size_t i = 0; i < length; i++) {
    int distance;
    int *first = pairs[0];
    int *second = pairs[1];
    bool first_greater = first[i] > second[i];

    distance = first_greater
      ? first[i] - second[i]
      : second[i] - first[i];

    sum += distance;
  }

  printf("Total of distances: %zu\n", sum);

  size_t sum_of_differences = 0;

  int *second = pairs[1];

  for (size_t i = 0; i < length; i++) {
    int total = 0;
    int num = pairs[0][i];

    while (second && num >= *second) {
      if (*second == num) {
        total++;
      }

      second++;
    }

    sum_of_differences += total * num;
  }

  printf("Total of differences: %zu\n", sum_of_differences);

  for (size_t i = 0; i < length; i++) {
    free(pair_strs[i]);
  }
  free(pair_strs);
  free(input);

  return 0;
}
