#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char *read_file(const char *filename, int *length) {
  if (!filename || !length) {
    return NULL;
  }
  size_t string_buffer_len = 8;
  size_t len = 0;
  char *string_buffer = malloc((string_buffer_len + 1) * sizeof(char));
  if (!string_buffer) {
    return NULL;
  }

  FILE *fp = fopen(filename, "r");
  if (!fp) {
    free(string_buffer);
    return NULL;
  }

  int ch;
  while ((ch = fgetc(fp)) != EOF) {
    if (len + 1 > string_buffer_len) {
      string_buffer_len *= 2;
      char *temp = realloc(
        string_buffer,
       ( string_buffer_len + 1) * sizeof(char)
      );

      if (!temp) {
        free(string_buffer);
        fclose(fp);
        return NULL;
      }

      string_buffer = temp;
    }

    string_buffer[len++] = ch;
  }

  string_buffer[len] = '\0';

  if (ferror(fp)) {
    fclose(fp);
    free(string_buffer);
    return NULL;
  }

  *length = len - 1;
  fclose(fp);
  return string_buffer;
}

static void free_string_buffer(char **string_buffer, size_t len) {
  for (size_t i = 0; i < len; i++) {
    free(string_buffer[i]);
  }
  free(string_buffer);
}

char **split_string(const char *string, const char *split, size_t *length) {
  if (!string || !split || !length) {
    return NULL;
  }

  char *string_copy = strdup(string);
  if (!string_copy) return NULL;

  int split_length = strlen(split);

  size_t array_size = 8;
  size_t return_len = 0;

  char **string_array = malloc(array_size * sizeof(char *));
  if (!string_array) {
    free(string_copy);
    return NULL;
  }

  char *offset = NULL;
  const char *head = string_copy;
  while ((offset = strstr(head, split)) != NULL) {
    *offset = '\0';

    char *string_buffer = strdup(head);
    if (!string_buffer) {
      free(string_copy);
      free_string_buffer(string_array, return_len);
      return NULL;
    }
    string_array[return_len++] = string_buffer;

    if (return_len >= array_size) {
      array_size *= 2;

      char **temp = realloc(string_array, array_size * sizeof(char *));
      if (!temp) {
        free(string_copy);
        free_string_buffer(string_array, array_size / 2);
        return NULL;
      }

      string_array = temp;
    }

    head = split_length + offset;
  }

  if (*head != '\0') {
    char *final_string = strdup(head); 
    if (!final_string) {
      free(string_copy);
      free_string_buffer(string_array, return_len);
      return NULL;
    }
    string_array[return_len++] = final_string;
  }

  free(string_copy);
  *length = return_len;

  char **final_array = realloc(string_array, return_len * sizeof(char *));
  if (final_array) {
    string_array = final_array;
  }
  return string_array;
}
