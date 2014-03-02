#import <Foundation/Foundation.h>

@class Mesh;

@interface ObjParser: NSObject {
    NSString* _filename;
    NSString* _currentLine;
    Mesh*     _currentMesh;

    float*          _vertexArray;
    unsigned int    _vertexSize;
    unsigned int*   _faceArray;
    unsigned int    _faceSize;
}

//! Initialization

-(id)initWithFileName:(NSString*)aFileName;
-(Mesh*)parse;

@end
