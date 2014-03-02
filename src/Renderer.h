#import <AppKit/NSOpenGLView.h>

#include "MathLib.h"

@class Mesh;
@class NSEvent;

//! A basic renderer class to manage GLUT
@interface Renderer: NSOpenGLView {
    Mesh*   _renderMesh;

    BOOL    _glInitialized;
    float   _position;
    float  _xRotation;
    float  _zRotation;
}

//! Initialization with application parameter. This method directly initialize GLUT.
-(id)init;

//! Set the render mesh to display
-(void)setMeshToRender:(Mesh*)mesh;

//! \name OpenGL management methods
//@{
-(void)glInit;
-(void)glRender;
-(void)glReshape:(int)width withHeight:(int)height;
//@}

//! \name Keyboard events handlers
//@{
-(void)keyDown:(NSEvent*)aEvent;
//@}


//! \name NSOpenGLView specific
//@{
-(void)drawRect:(NSRect)bounds;
//@}

@end

