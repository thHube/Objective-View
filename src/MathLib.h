#ifndef MATHLIB__H
#define MATHLIB__H

#include <stdlib.h>
#include <string.h>

typedef float Vec2_t[2];
typedef float Vec3_t[3];
typedef float Mat44_t[4][4];
typedef float Normal_t[3];
typedef unsigned int Tri_t[3];

#define cross3(dst, fst, snd)                               \
    (dst)[0] = (fst)[1] * (snd)[2] - (fst)[2] * (snd)[1];   \
    (dst)[1] = (fst)[2] * (snd)[0] - (fst)[0] * (snd)[2];   \
    (dst)[2] = (fst)[0] * (snd)[1] - (fst)[1] * (snd)[0]

#define add3(dst, fst, snd)         \
    (dst)[0] = (fst)[0] + (snd)[0]; \
    (dst)[1] = (fst)[1] + (snd)[1]; \
    (dst)[2] = (fst)[2] + (snd)[2]

#define sub3(dst, fst, snd)         \
    (dst)[0] = (fst)[0] - (snd)[0]; \
    (dst)[1] = (fst)[1] - (snd)[1]; \
    (dst)[2] = (fst)[2] - (snd)[2]

#define dot3(fst, snd) \
    (fst)[0] * (snd)[0] + (fst)[1] * (snd)[1] + (fst)[2] * (snd)[2]

#define sqlength3(vec) dot3(vec, vec)

#define length3(vec) sqrt(sqlength3(vec))


#endif // MATHLIB__H
