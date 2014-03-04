#import "AppController.h"

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <stdlib.h>
#include <GL/glew.h>


int main(int argc, char* argv[]) 
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    AppController* delegate = [[AppController alloc] init];

    [NSApplication sharedApplication];
    [NSApp setDelegate: delegate];

    if (!glewInit()) {
        NSLog(@"Could not initialize GLEW. Exiting");
        return EXIT_FAILURE;
    }
    
    RELEASE(pool);
    return NSApplicationMain(argc, (const char**)argv);
}

