#import <Foundation/Foundation.h>
#import "Mesh.h"

//! Builder category for the mesh. The parser will be able to build 
//! a mesh using this category. 
@interface Mesh(Builder)

-(void)setVertexArray:(float*)vertex;
-(void)setUVArray:(float*)uv;
-(void)setNormalArray:(float*)normal;
-(void)setTriangleArray:(unsigned int*)vertex;

-(void)setTriangleCount:(unsigned int)count;
-(void)setVertexCount:(unsigned int)count;
@end
