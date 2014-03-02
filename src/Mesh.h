#import <Foundation/Foundation.h>

#import "MathLib.h"
#import "RenderableObject.h"

//!
@interface Mesh: NSObject<RenderableObject> {
    // Data
    float* _vertex;
    float* _uvmap;
    float* _normal;
    unsigned int* _triangle;
    // Data count
    unsigned int _vertexCount;
    unsigned int _triangleCount;
    // GL handlers
    unsigned int _listId;
}

-(id)init;

-(void)allocateOnGpu;
-(void)render;


@end

