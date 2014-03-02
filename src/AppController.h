#import <Foundation/NSObject.h>

@class NSWindow;
@class Renderer;
@class NSNotification;

@interface AppController: NSObject {
    NSWindow* _window;
    Renderer* _renderer;
}

//! \name Application delegate implementation 
//@{
- (void)applicationWillFinishLaunching:(NSNotification *) aNotification;
- (void)applicationDidFinishLaunching:(NSNotification *) aNotification;
//@}

-(void)loadMesh:(NSString*)filename;
-(void)openDialogLoadMesh;

@end //< AppController

