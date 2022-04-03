
// -------------------------------------------------------------------------- //

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <assert.h>

// -------------------------------------------------------------------------- //

#define NUM_ALLOCS 20

#define POINTER_SIZE "10"
#define BLOCK_FORMATTER "(%s) : %" POINTER_SIZE "p, .prev: %" POINTER_SIZE "p, .next: %" POINTER_SIZE "p (%5ld Bytes)\n"

// -------------------------------------------------------------------------- //

// #ifdef DEBUG
    extern void * BRK_END;
    extern void * BRK_START;
// #endif

// -------------------------------------------------------------------------- //

void print_headers ();
bool check_memory_integrity();

// -------------------------------------------------------------------------- //

typedef struct MemoryField {
    void * next;
    void * prev;
    uint8_t state;
} Memory;

// -------------------------------------------------------------------------- //

int main () {

    assert(check_memory_integrity());

    void ** buffer = malloc(sizeof(void *) * NUM_ALLOCS);
    if (buffer == NULL) return -1;

    assert(check_memory_integrity());

    for (size_t i = 0; i < NUM_ALLOCS; i++)
        buffer[i] = malloc(sizeof(void *) * i);

    assert(check_memory_integrity());

    print_headers();

    for (size_t i = 0; i < NUM_ALLOCS; i++)
        free(buffer[i]);

    assert(check_memory_integrity());

    print_headers();

    for (size_t i = 0; i < NUM_ALLOCS; i++)
        buffer[i] = malloc(sizeof(void *) * 20);

    assert(check_memory_integrity());

    print_headers();

    return 0;

}

// -------------------------------------------------------------------------- //

void print_headers () {
    // Get first Block
    Memory * header = BRK_START - sizeof(Memory);
    void * mem = BRK_START;

    printf(
        "First Block " BLOCK_FORMATTER,
        (header->state ? "U" : "F"), mem, NULL, header->next,
        (long) ((header->next - mem - sizeof(Memory)) / 8)
    );

    // Check if only one Block exists
    if (header->next == NULL) return;

    mem = header->next;
    header = header->next - sizeof(Memory);

    // Keep looping until no more Blocks remain
    while (header->next != NULL) {
        printf(
            "Block       " BLOCK_FORMATTER,
            (header->state ? "U" : "F"), mem, header->prev, header->next,
            (long) ((header->next - mem - sizeof(Memory)) / 8)
        );
        // Get next Block
        mem = header->next;
        header = header->next - sizeof(Memory);
    }

    printf(
        "Last Block  " BLOCK_FORMATTER "\n",
        (header->state ? "U" : "F"), mem, header->prev, header->next,
        (long) ((BRK_END - mem - sizeof(Memory)) / 8)
    );

}

// -------------------------------------------------------------------------- //

bool check_memory_integrity() {

    Memory * header = BRK_START - sizeof(Memory), * prev_block = NULL;
    bool prev_is_free = !header->state;

    // Check that the first Block has no previous Block
    if (header->prev != NULL) return false;
    // Check if there is only one Block
    if (header->next == NULL) return true;

    prev_block = ((void *) header) + sizeof(Memory);
    header = header->next - sizeof(Memory);

    // Keep looping until no more Blocks remain
    while (header->next != NULL) {
        // Check that the Blocks are linked correctly and
        // that freed Blocks are merged.
        if (prev_block != header->prev) return false;
        if ((!header->state) && prev_is_free) return false;

        // Get next Block
        prev_block = ((void *) header) + sizeof(Memory);
        prev_is_free = !header->state;
        header = header->next - sizeof(Memory);
    }

    if (prev_block != header->prev) return false;
    // Check if two free Blocks follow one another
    if ((!header->state) && prev_is_free) return false;

    return true;

}

// -------------------------------------------------------------------------- //
