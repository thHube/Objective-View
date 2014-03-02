#import "Renderer.h"
#import "Mesh.h"

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <GL/gl.h>
#include <GL/glu.h>

static const int DEFAULT_WITDH  = 640;
static const int DEFAULT_HEIGHT = 480;

static const float SPEED = 0.05f;

@implementation Renderer

-(BOOL)acceptsFirstResponder { return YES; }

-(id)init
{
    self = [super init];
    if (self) {
        self->_glInitialized = NO;
        self->_renderMesh = nil;

        self->_position = -5.0f;
        self->_xRotation = 0.0f;
        self->_zRotation = 0.0f;

        [self setNeedsDisplay:YES];
    }
    return self;
}


-(void)glInit
{

}


-(void)glRender
{
    glClearColor(0.1, 0.4, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glTranslatef(0.0f, 0.0f, _position);

    glRotatef(_xRotation, 1.0f, 0.0f, 0.0f);
    glRotatef(_zRotation, 0.0f, 0.0f, 1.0f);
    /*
    glBegin(GL_TRIANGLES);
        glVertex3f(-2,-2,0.0);
        glVertex3f(2,0.0,0.0);
        glVertex3f(0.0,2,0.0);
    glEnd();
    */
    if (_renderMesh)
        [_renderMesh render];
}


-(void)glReshape:(int)width withHeight:(int)height
{
    double ratio = (double)width / (double)height;
    glViewport(0, 0, width, height);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0, ratio, 0.5, 100.0);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}   


-(void)drawRect:(NSRect)bounds
{
    if (!_glInitialized) {
        [self glInit];
        _glInitialized = YES;
    }
    // Reshape
    NSRect frameRect = [self frame];
    [self glReshape:frameRect.size.width withHeight: frameRect.size.height];
    
    // Render
    [self glRender];
    glFlush();

    [[self openGLContext] flushBuffer];
}


-(void)keyDown:(NSEvent*)aEvent
{
    NSString* chars = [aEvent characters];
    for (int i = 0; i < [chars length]; ++i) {
        unichar c = [chars characterAtIndex:i];
        switch (c) {
            case 'w':
                _position += SPEED;
                break;
            case 's':
                _position -= SPEED;
                break;
        }
    }
    [self setNeedsDisplay:YES];
}


-(void)setMeshToRender:(Mesh*)mesh
{
    _renderMesh = mesh;
}

-(void)dealloc
{
    [super dealloc];
    TEST_RELEASE(_renderMesh);
}

@end

