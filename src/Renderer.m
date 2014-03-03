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
-(BOOL)acceptsFirstMouse:(NSEvent*)aEvent { return YES; }

-(id)init
{
    self = [super init];
    if (self) {
        self->_glInitialized = NO;
        self->_renderMesh = nil;

        self->_position = -15.0f;
        self->_xRotation = 0.0f;
        self->_yRotation = 0.0f;

        [self setNeedsDisplay:YES];
    }
    return self;
}


-(void)glInit
{
    GLfloat mat_specular[] = { 1.0, 0.8, 1.0, 1.0 };
    GLfloat mat_shininess[] = { 50.0 };
    GLfloat light_position[] = { 0.0, 10.0, -10.0, 0.0 };

    glShadeModel (GL_SMOOTH);

    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
}


-(void)glRender
{
    glClearColor(0.1, 0.4, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glTranslatef(0.0f, 0.0f, _position);

    glRotatef(_xRotation, 1.0f, 0.0f, 0.0f);
    glRotatef(_yRotation, 0.0f, 1.0f, 0.0f);
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


-(void)mouseDown:(NSEvent*)aEvent
{
    _lastDragLocation = [[self superview] convertPoint:[aEvent locationInWindow]
                                              fromView:nil];
}


-(void)mouseDragged:(NSEvent*)aEvent
{
    NSPoint newDragLocation = [[self superview] convertPoint:[aEvent locationInWindow]
                                                    fromView:nil];
    
    _yRotation += (newDragLocation.x - _lastDragLocation.x) * SPEED;
    _xRotation -= (newDragLocation.y - _lastDragLocation.y) * SPEED;
    // Invalidate view
    [self setNeedsDisplay:YES];
}


-(void)setMeshToRender:(Mesh*)mesh
{
    _renderMesh = mesh;
    if ([_renderMesh needsNormalCalculation]) {
        [_renderMesh recalculateNormals];
        [_renderMesh allocateOnGpu];
    }
}

-(void)dealloc
{
    [super dealloc];
    TEST_RELEASE(_renderMesh);
}

@end

