#import <Foundation/Foundation.h>

@protocol RenderableObject <NSObject>

-(void)allocateOnGpu;
-(void)render;

@end

