#pragma once

#include <stdlib.h>
#include <stdbool.h>

typedef struct esw_HashMap esw_HashMap;

/** 
 * @param size_t element_size sizeof the type of all entries in the HashMap
 * @param initial_size Number of elements to preallocate, to avoid the overhead
 *   of resizing
 * @param free_element Function to free the supplied element. May be NULL if no
 *   additional action is needed.
 * @return HashMap
 */
esw_HashMap *create_hashmap(
  size_t element_size,
  size_t initial_size,
  void (*free_element)(void *)
);

/** @return int Number of elements in the esw_HashMap */
int hashmap_size(esw_HashMap *h);

void hashmap_put(esw_HashMap *h, char *key, void *element);

void *hashmap_get(esw_HashMap *h, char *key);

void hashmap_free(esw_HashMap *h);
