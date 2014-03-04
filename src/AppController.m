#import "AppController.h"

// Project import
#import "Renderer.h"
#import "Mesh.h"
#import "ObjParser.h"

// NextStep importing 
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// C inclusion 
#include <GL/gl.h>

@implementation AppController

- (void)applicationWillFinishLaunching:(NSNotification *) aNotification
{
    NSMenu* menu;
    NSMenu* info;

    menu = [NSMenu new];
    [menu addItemWithTitle: @"Open mesh"
                    action: @selector(openDialogLoadMesh)
             keyEquivalent: @""];

    [menu addItemWithTitle: @"Info"
                    action: NULL
             keyEquivalent: @""];

    [menu addItemWithTitle: @"Hide"
                    action: @selector(hide:)
             keyEquivalent: @"h"];

    [menu addItemWithTitle: @"Quit" 
                    action: @selector(terminate:) 
             keyEquivalent: @"q"];

    info = [NSMenu new];
    [info addItemWithTitle: @"About.. "
                    action: @selector(orderFrontStandardInfoPanel:)
             keyEquivalent: @""];

    [menu setSubmenu: info 
             forItem: [menu itemWithTitle: @"Info"]];
    RELEASE(info);

    [NSApp setMainMenu: menu];
    RELEASE(menu);

    _window = [[NSWindow alloc] initWithContentRect: NSMakeRect(200, 200, 640, 480)
                                          styleMask: (NSTitledWindowMask |
                                                      NSMiniaturizableWindowMask |
                                                      NSResizableWindowMask)
                                            backing: NSBackingStoreBuffered
                                              defer: YES];
    [_window setTitle: @"First test"];

    _renderer = [[Renderer alloc]initWithFrame:[_window frame]];
    [_window setContentView: _renderer];

    [[_window standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [_window makeFirstResponder:_renderer];
    [_window makeKeyWindow];
}

- (void)applicationDidFinishLaunching:(NSNotification *) aNotification
{
    [_window makeKeyAndOrderFront: self];
}

-(void)loadMesh:(NSString*)filename
{
    ObjParser* loader = [[ObjParser alloc] initWithFileName:filename];
    Mesh* newMesh = [loader parse];
    if (newMesh) 
        [_renderer setMeshToRender:newMesh];
    // Invalidate the renderer so it gets redisplayed 
    [_renderer setNeedsDisplay: YES];
}

-(void)openDialogLoadMesh
{
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:YES];
    [openDialog setAllowsMultipleSelection:NO];
    [openDialog setCanChooseDirectories:NO];

    if ([openDialog runModalForDirectory:nil file:nil] == NSOKButton) {
        NSArray* filenames = [openDialog filenames];
        NSString* choice = [filenames objectAtIndex:0];
        [self loadMesh:choice];
    }
}

- (void)dealloc
{
    RELEASE(_window);
    RELEASE(_renderer);
    [super dealloc];
}

@end
