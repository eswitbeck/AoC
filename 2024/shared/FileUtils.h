#pragma once

#include <stdio.h>

/** Reads file into single string, updating length to the strlen of 
 * the read string
 */
char *read_file(const char *filename, size_t *length);

/** Returns an array of null-terminated strings split on the specified string
 * EXCLUDING the split characters themselves. Updates length to the length of
 * the array.
 */
char **split_string(const char *string, const char *split, size_t *length);
