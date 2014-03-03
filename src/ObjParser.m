#import "ObjParser.h"
#import "Mesh+Builder.h"

#include <stdio.h>

@interface ObjParser()
// obj parsing support
-(void)readFace:(NSString*)line;
-(void)readVector:(NSString*)line;
-(void)readUV:(NSString*)line;
-(void)readNormal:(NSString*)line;

@end 

@implementation ObjParser 

-(id)initWithFileName:(NSString*)aFileName
{
    if (self = [super init]) {
        self->_filename = aFileName;
        self->_currentLine = 0;
        self->_currentMesh = [[Mesh alloc] init];

        self->_vertexArray = NULL;
        self->_vertexSize = 0;

        self->_faceArray = NULL;
        self->_faceSize = 0;
    }
    return self;
}


-(Mesh*)parse
{
    NSString* fileString = [NSString stringWithContentsOfFile:_filename];
    NSArray* lines = [fileString componentsSeparatedByCharactersInSet:
        [NSCharacterSet newlineCharacterSet]];
    int vertCount = 0;
    int uvCount = 0;
    int normCount = 0;
    int triCount = 0;

    // Sigh, wish Objective-C has some decent containers.
    _vertexArray = (float*)malloc(sizeof(float) * [lines count] * 3);
    _faceArray = (unsigned int*)malloc(sizeof(unsigned int) * [lines count] * 3);

    for (int i = 0; i < [lines count]; ++i) {
        // get current line and split it along whitespace  
        NSString* current = [[lines objectAtIndex:i] retain];
        if ([current length] == 0)
            continue;

        NSArray* split = [current componentsSeparatedByString:@" "];

        int j = 0;
        if ([split count] > 0) {
            
            // move to the first valid string
            while([[split objectAtIndex:j] length] == 0) ++j;
        }

        if (j < [split count]) {
            
            NSString* selector = [[split objectAtIndex:j] retain];
            if ([selector isEqual:@"v"]) {
                vertCount ++;
                [self readVector: current];
            }
            else if ([selector isEqual:@"vt"]) {
                uvCount ++;
            }
            else if ([selector isEqual:@"vn"]) {
                normCount ++;
            }   
            else if ([selector isEqual:@"f"]) {
                [self readFace: current];
                triCount ++;
            }
            else if (![selector isEqual:@"#"]) {
                NSLog(@"Unsupported selector found");
            }
        }
    }
    
    float* verts = (float*)malloc(sizeof(float) * 3 * _vertexSize);
    unsigned int* faces = (unsigned int*)malloc(sizeof(unsigned int) * 3 * _faceSize);

    memcpy(verts, _vertexArray, sizeof(float) * 3 * _vertexSize);
    memcpy(faces, _faceArray, sizeof(unsigned int) * 3 * _faceSize);

    free(_vertexArray); _vertexArray = NULL;
    free(_faceArray); _faceArray = NULL;

    [_currentMesh setVertexArray:verts];
    [_currentMesh setVertexCount:_vertexSize / 3];

    [_currentMesh setTriangleArray:faces];
    [_currentMesh setTriangleCount:_faceSize / 3];

    NSLog([NSString stringWithFormat: @"Got %d vertices, %d uvs, %d normal and %d faces",
        vertCount, uvCount, normCount, triCount]);

    [_currentMesh allocateOnGpu];
    return [_currentMesh retain];
}


-(void)readFace:(NSString*)line
{
    NSArray* split = [line componentsSeparatedByString:@" "];

    if ([split count] <= 4) {
        for (int i = 1; i < 4; ++i) {
            NSArray* innerSplit = [[split objectAtIndex:i] componentsSeparatedByString:@"/"];
            if ([innerSplit count] == 1) {
                _faceArray[_faceSize++] = [[split objectAtIndex:i] intValue] - 1;
            } 
            else {
                NSLog(@"Multi attribute vertex still unsupported");
            }
        }
    } else {
        NSLog(@"Quads not supported");
    }
}


-(void)readVector:(NSString*)line
{
    NSArray* split = [line componentsSeparatedByString:@" "];

    _vertexArray[_vertexSize] = [[split objectAtIndex: 1] floatValue];
    _vertexArray[_vertexSize + 1] = [[split objectAtIndex: 2] floatValue];
    _vertexArray[_vertexSize + 2] = [[split objectAtIndex: 3] floatValue];

    _vertexSize += 3;
}

-(void)readUV:(NSString*)line
{

}


-(void)readNormal:(NSString*)line
{

}

-(void)dealloc 
{
    [super dealloc];
    RELEASE(_currentMesh);
}


@end