#ifndef MATHLIB__H
#define MATHLIB__H

#include <stdlib.h>
#include <string.h>

typedef float Vec2_t[2];
typedef float Vec3_t[3];
typedef float Mat44_t[4][4];
typedef float Normal_t[3];
typedef unsigned int Tri_t[3];

#define DECLARE_ARRAY(Type)                                                                 \
typedef struct {                                                                            \
    Type ## _t* list;                                                                       \
    size_t size;                                                                            \
    size_t capacity;                                                                        \
} Type ## Array_t;                                                                          \
                                                                                            \
static inline void Type ## Array_pushBack(Type ## Array_t* arr, Type ## _t* item)           \
{                                                                                           \
    if (arr->size == arr->capacity) {                                                       \
        Type ## _t* newarr = (Type ## _t*)malloc(arr->capacity * 2 * sizeof(Type ## _t));   \
        memcpy(newarr, arr->list, arr->size * sizeof(Type ## _t));                          \
        free(arr->list);                                                                    \
        arr->list = newarr;                                                                 \
        arr->capacity *= 2;                                                                 \
    }                                                                                       \
    arr->size += 1;                                                                         \
    memcpy(arr->list + arr->size, item, sizeof(Type ## _t));                                \
}

#define INIT_ARRAY(array)   \
    array.list = NULL;      \
    array.size = 0;         \
    array.capacity = 1


DECLARE_ARRAY(Vec2);
DECLARE_ARRAY(Vec3);
DECLARE_ARRAY(Normal);
DECLARE_ARRAY(Tri);
#undef DECLARE_ARRAY

#endif // MATHLIB__H
