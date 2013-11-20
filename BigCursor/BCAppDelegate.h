#import <Cocoa/Cocoa.h>

@interface BCAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)enable:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
