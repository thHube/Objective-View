#import "Mesh.h"
#import "MathLib.h"

#include <GL/gl.h>
#include <stdlib.h>
#include <math.h>

@implementation Mesh

-(id)init
{
    if (self = [super init]) {
        _vertex = NULL;
        _uvmap = NULL;
        _normal = NULL;
        _triangle = NULL;

        _listId = 0;
    }
}


-(void)allocateOnGpu
{
    if (_listId != 0) 
        glDeleteLists(_listId, 1);

    _listId = glGenLists(1);
    glNewList(_listId, GL_COMPILE);
    if (_vertex && _triangle) {
        glBegin(GL_TRIANGLES);
        for (int i = 0; i < _triangleCount * 3; ++i) {
            unsigned int first = _triangle[i] * 3;
            if (_normal) {
                glNormal3f(_normal[first], _normal[first + 1], _normal[first + 2]);
            }

            glVertex3f(_vertex[first], _vertex[first + 1], _vertex[first + 2]);
        }
        glEnd();
    }
    glEndList();
}

-(void)render
{
    glCallList(_listId);
}

-(void)recalculateNormals 
{
    if (_normal)
        free(_normal);

    _normal = (float*)malloc(sizeof(float) * 3 * _vertexCount);
    memset(_normal, 0, sizeof(float) * 3 * _vertexCount);

    for (int i = 0; i < _triangleCount; i++) {
        Vec3_t fst;
        Vec3_t snd;

        // calculate first
        fst[0] = _vertex[_triangle[i + 2  * 3]] - _vertex[_triangle[i * 3]];
        fst[1] = _vertex[_triangle[i + 2  * 3] + 1] - _vertex[_triangle[i * 3] + 1];
        fst[2] = _vertex[_triangle[i + 2  * 3] + 2] - _vertex[_triangle[i * 3] + 2];
        // calculate snd
        snd[0] = _vertex[_triangle[i + 1  * 3]] - _vertex[_triangle[i] * 3];
        snd[1] = _vertex[_triangle[i + 1  * 3] + 1] - _vertex[_triangle[i * 3] + 1];
        snd[2] = _vertex[_triangle[i + 1  * 3] + 2] - _vertex[_triangle[i * 3] + 2];        

        Normal_t normal;
        // Cross product fst x second to obtain normal
        normal[0] = fst[1] * snd[2] - fst[2] * snd[1];
        normal[1] = fst[2] * snd[0] - fst[0] * snd[2];
        normal[2] = fst[0] * snd[1] - fst[1] * snd[0];
        // add the product to the right point
        _normal[_triangle[i * 3]] = normal[0];
        _normal[_triangle[i * 3] + 1] = normal[1];
        _normal[_triangle[i * 3] + 2] = normal[2];
    }

    for (int i = 0; i < _vertexCount; i++) {
        // normalize 
        float length =  sqrt(_normal[i * 3] * _normal[i * 3] + 
                        _normal[i * 3 + 1] * _normal[i * 3 + 1] + 
                        _normal[i * 3 + 2] * _normal[i * 3 + 2]);
        _normal[i * 3] /= length;
        _normal[i * 3 + 1] /= length;
        _normal[i * 3 + 2] /= length;
    }
}

-(void)dealloc
{
    [super dealloc];
    if (_vertex) {
        free(_vertex);
    }

    if (_uvmap) {
        free(_uvmap);
    }

    if (_normal) {
        free(_normal);
    }

    if (_triangle) {
        free(_triangle);
    }

    if (_listId != 0)
        glDeleteLists(_listId, 1);
}

@end 

