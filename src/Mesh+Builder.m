#import "Mesh+Builder.h"

@implementation Mesh(Builder)

-(void)setVertexArray:(float*)vertex { _vertex = vertex; }
-(void)setUVArray:(float*)uv         { _uvmap  = uv; }
-(void)setNormalArray:(float*)normal { _normal = normal; }

-(void)setTriangleArray:(unsigned int*)tri { _triangle = tri; }

-(void)setTriangleCount:(unsigned int)count { _triangleCount = count; }
-(void)setVertexCount:(unsigned int)count   { _vertexCount = count; }
@end

