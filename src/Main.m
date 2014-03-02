#import "AppController.h"

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <stdlib.h>
#include <GL/gl.h>


int main(int argc, char* argv[]) 
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    AppController* delegate = [[AppController alloc] init];

    [NSApplication sharedApplication];
    [NSApp setDelegate: delegate];

    /*
    Renderer* renderer = [[Renderer alloc] initWithArgs:&argc argVector:argv];
    renderer.renderFunc = render;

    ObjParser* parser = [[ObjParser alloc] initWithFileName:@"test_data/cow.obj"];
    Mesh* mesh = [parser parse];

    NSString* title = @"Test title!";

    [renderer renderMainLoop:title];
    */

    RELEASE(pool);
    return NSApplicationMain(argc, (const char**)argv);
}

