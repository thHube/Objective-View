#import <Foundation/Foundation.h>

@interface Shader: NSObject {
    unsigned int _glProgram;
    unsigned int _glVertex;
    unsigned int _glPixel;
}

-(id)initWithFilename:(NSString*)vsFilename pixelShader:(NSString*)psFilename;
-(void)bind;

@end
