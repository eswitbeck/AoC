#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "../HashMap.h"

void free_string(void *string);

int main () {
  esw_HashMap *map = create_hashmap(
      sizeof(char *),
      2,
      free_string
  );

  for (int i = 0; i < 90; i++) {
    char str[3];
    snprintf(str, sizeof(str), "%c%c", i + 35, '!');

    hashmap_put(map, str, strdup(str));
    printf(
        "element at %s is %s\n",
        str,
        (char *) hashmap_get(map, str)
    );
  }

  printf("total size of map is %d\n", hashmap_size(map));

  esw_HashMap *num_map = create_hashmap(
    sizeof(int),
    2,
    NULL
  );

  for (int i = 0; i < 90; i++) {
    char key[3];
    snprintf(key, sizeof(key), "%d", i);

    hashmap_put(num_map, key, (void *)(intptr_t)i);
    printf(
        "element at \"%s\" is %d\n",
        key,
        (int)(intptr_t)hashmap_get(num_map, key)
    );
  }

  printf("total size of map is %d\n", hashmap_size(num_map));

  for (int i = 0; i < 90; i++) {
    char key[3];
    snprintf(key, sizeof(key), "%d", i);

    hashmap_put(num_map, key, (void *)(intptr_t)-1);
    printf(
        "element at \"%s\" is %d\n",
        key,
        (int)(intptr_t)hashmap_get(num_map, key)
    );
  }

  printf("total size of map is %d\n", hashmap_size(num_map));

  hashmap_free(map);
  hashmap_free(num_map);

  return 0;
}

void free_string(void *string) {
  free(string);
}
