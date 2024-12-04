#include <stdlib.h>
#include <stdio.h>
#include "../FileUtils.h"

void test_file_read();
void test_string_split();

int main() {
  test_file_read();
  test_string_split();

  return 0;
}

void test_file_read() {
  char *valid_file = "test/TestFileUtils.txt";
  char *invalid_file = "foo";

  size_t length = 0;
  char *valid_file_string = read_file(valid_file, &length);
  printf("length: %zu\n"
    "file contents: %s\n",
    length,
    valid_file_string
  );

  length = 0;
  char *invalid_file_string = read_file(invalid_file, &length);
  printf("length: %zu\n"
    "file contents: %s\n",
    length,
    invalid_file_string
  );

  if (valid_file_string) {
    free(valid_file_string);
  }
  if (invalid_file_string) {
    free(invalid_file_string);
  }
}

void free_string_array(char **str_arr, size_t len) {
  for (size_t i = 0; i < len; i++) {
    free(str_arr[i]);
  }
  free (str_arr);
}

void test_string_split() {
  const char *test_cases[] = {
    "abcde",
    "abcfoodefoofgh",
    "abcfoo"
  };

  size_t cases_len = sizeof(test_cases) / sizeof(test_cases[0]);

  for (size_t j = 0; j < cases_len; j++) {
    printf("Testing string: %s\n", test_cases[j]);
    size_t len = 0;
    char **arr = split_string(test_cases[j], "foo", &len);

    if (!arr) {
      printf("Done broke!\n");
    } else {
      for (size_t i = 0; i < len; i++) {
        printf("[%zu]: %s\n", i, arr[i]);
      }
      free_string_array(arr, len);
    }
  }
}
