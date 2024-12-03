#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#define esw_BUCKET_CAPACITY_THRESHOLD 0.75

typedef struct _esw_ListNode {
  void *item;
  char *key;
  struct _esw_ListNode *next;
} _esw_ListNode;

typedef struct {
  size_t length;
  _esw_ListNode *contents; // points to linked list head
} _esw_Bucket;

typedef struct {
  size_t element_size;
  size_t number_of_buckets;
  size_t total_size;
  _esw_Bucket *buckets; // contiguous array
  void (*free_element)(void *);
} esw_HashMap;


esw_HashMap *create_hashmap(
  size_t element_size,
  size_t initial_size,
  void (*free_element)(void *)
) {
  esw_HashMap *h = malloc(sizeof(esw_HashMap));
  if (!h) {
    return NULL;
  }

 h->buckets = (_esw_Bucket *)calloc(initial_size, sizeof(_esw_Bucket));
  if (!h->buckets) {
    free(h);
    return NULL;
  }

  h->number_of_buckets = initial_size;
  h->element_size = element_size;
  h->free_element = free_element;
  h->total_size = 0;

  return h;
}

int hashmap_size(esw_HashMap *h) {
  return h ? h->total_size : 0;
}

static size_t hash(char *key, size_t number_of_buckets){
  if (!key || 0 == number_of_buckets) {
    return -1;
  }

  uint64_t hash = 0;
  char c;
  while ((c = *key++) != '\0') {
    hash = hash * 31 + c;
  }

  return hash % number_of_buckets;
}

void hashmap_put(esw_HashMap *h, char *key, void *element) {
  if (!h || !key) {
    return;
  }

  // TODO needs writing to a new buffer and rehashing all existing elements
  if (h->total_size > esw_BUCKET_CAPACITY_THRESHOLD * h->number_of_buckets) {
    h->number_of_buckets *= 2;
    _esw_Bucket *buckets_buffer =
      realloc(h->buckets, h->number_of_buckets * sizeof(_esw_Bucket));

    if (!buckets_buffer) {
      h->number_of_buckets /= 2;
      return;
    }
    h->buckets = buckets_buffer;
  }

  size_t bucket_i = hash(key, h->number_of_buckets);
  _esw_Bucket *bucket = &h->buckets[bucket_i];

  _esw_ListNode *head = bucket->contents;

  _esw_ListNode *new_node = malloc(sizeof(_esw_ListNode));
  if (!new_node) {
    return;
  }

  if (!head) {
    bucket->contents = new_node;

    bucket->contents->item = element;
    bucket->contents->key = strdup(key);
    bucket->contents->next = NULL;
    bucket->length = 1;
    h->total_size++;

    return;
  }

  new_node->item = element;
  new_node->key = strdup(key);
  new_node->next = NULL;

  _esw_ListNode *prev;
  while(head) {
    if (0 == strcmp(head->key, key)) {
      head->item = element;
      return;
    }
    prev = head;
    head = head->next;
  }

  prev->next = new_node;
  bucket->length++;

  h->total_size++;
}

void *hashmap_get(esw_HashMap *h, char *key) {
  if (!key || !h) {
    return NULL;
  }
  size_t bucket_i = hash(key, h->number_of_buckets);
  _esw_Bucket *bucket = &h->buckets[bucket_i];
  if (0 == bucket->length) {
    return NULL;
  }
  _esw_ListNode *head = bucket->contents;

  while (head && strcmp(key, head->key) != 0) {
    head = head->next;
  }

  return head ? head->item : NULL;
}

void hashmap_free(esw_HashMap *h) {
  if (!h) {
    return;
  }
  for (size_t i = 0; i < h->number_of_buckets; i++) {
    _esw_Bucket *b = &h->buckets[i];
    if (b->contents) {
      _esw_ListNode *head = b->contents;
      while (head) {
        _esw_ListNode *temp = head->next;
        if (h->free_element && head->item) {
          h->free_element(head->item);
        }
        free(head->key);
        free(head);
        head = temp;
      }
    }
  }

  free(h->buckets);
  free(h);
}
