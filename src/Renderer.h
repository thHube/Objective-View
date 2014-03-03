#import <AppKit/NSOpenGLView.h>
#import <Foundation/Foundation.h>

#include "MathLib.h"

@class Mesh;
@class NSEvent;

//! A basic renderer class to manage GLUT
@interface Renderer: NSOpenGLView {
    Mesh*   _renderMesh;

    BOOL    _glInitialized;
    float   _position;
    float  _xRotation;
    float  _yRotation;

    NSPoint _lastDragLocation;
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

//! \name Input events handlers
//@{
-(void)keyDown:(NSEvent*)aEvent;
-(void)mouseDown:(NSEvent*)aEvent;
-(void)mouseDragged:(NSEvent*)aEvent;
//@}


//! \name NSOpenGLView specific
//@{
-(void)drawRect:(NSRect)bounds;
//@}

@end

