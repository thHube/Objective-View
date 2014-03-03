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

    for (int i = 0; i < _triangleCount * 3; i += 3) {
        Vec3_t fst;
        Vec3_t snd;
        unsigned int first = _triangle[i] * 3;
        unsigned int second = _triangle[i + 1] * 3;
        unsigned int third = _triangle[i + 2] * 3;

        // calculate first and second vertex
        sub3(fst, _vertex + third, _vertex + first);
        sub3(snd, _vertex + second, _vertex + first);

        Normal_t normal;
        // Cross product fst x second to obtain normal
        cross3(normal, fst, snd);
        // add the product to the right point
        add3(_normal + first, _normal + first, normal);
        add3(_normal + second, _normal + second, normal);
        add3(_normal + third, _normal + third, normal);
    }

    for (int i = 0; i < _vertexCount; i++) {
        // normalize 
        float length =  length3(_normal + (i * 3));
        _normal[i * 3]      /= length;
        _normal[i * 3 + 1]  /= length;
        _normal[i * 3 + 2]  /= length;
    }
}

-(BOOL)needsNormalCalculation
{
    return _normal == NULL;
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

