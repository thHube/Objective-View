#import "Mesh.h"

#include <GL/gl.h>

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

