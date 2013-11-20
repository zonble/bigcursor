#import "BCAppDelegate.h"

static CGEventRef MyEventTapCallBack (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon);

@interface BCAppDelegate ()
- (void)startTracking;
- (void)endTracking;
@end

@implementation BCAppDelegate
{
	CFMachPortRef eventTapPortRef;
	CFRunLoopSourceRef source;

	NSStatusItem *statusItem;
	BOOL enabled;
}

- (void)dealloc
{
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];

	if (source) {
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
		CFRelease(source);
		source = NULL;
	}

	if (eventTapPortRef) {
		CGEventTapEnable(eventTapPortRef, NO);
		CFRelease(eventTapPortRef);
		eventTapPortRef = NULL;
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self.window setAlphaValue:0.5];

	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:80.0];
	[statusItem setTitle:@"Big Cursor"];
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Big Cursor"];
	NSMenuItem *enableItem = [menu addItemWithTitle:@"Enabled" action:@selector(enable:) keyEquivalent:@""];
	[enableItem setTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];
	[menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
	[statusItem setMenu:menu];

	enabled = YES;

	[self startTracking];
}

- (void)startTracking
{
	CGEventRef ourEvent = CGEventCreate(NULL);
	CGPoint p = CGEventGetLocation(ourEvent);
	[self moveWindowToPoint:p];
	CFRelease(ourEvent);

	if (!eventTapPortRef) {
		CGEventMask mask = \
			CGEventMaskBit(kCGEventMouseMoved) |
			CGEventMaskBit(kCGEventLeftMouseDragged) |
			CGEventMaskBit(kCGEventRightMouseDragged);
		eventTapPortRef = CGEventTapCreate(kCGSessionEventTap, kCGTailAppendEventTap, 0, mask, MyEventTapCallBack, (__bridge void *)(self));
	}
	if (!source) {
		source = CFMachPortCreateRunLoopSource(NULL, eventTapPortRef, 0);
		CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
	}
	if (!CGEventTapIsEnabled(eventTapPortRef)) {
		CGEventTapEnable(eventTapPortRef, YES);
	}
	[self.window orderFront:nil];
}

- (void)endTracking
{
	[self.window orderOut:nil];
	if (eventTapPortRef) {
		CGEventTapEnable(eventTapPortRef, NO);
	}
}

- (void)moveWindowToPoint:(CGPoint)p
{
	p.y = [[NSScreen mainScreen] frame].size.height - p.y;
	p.y -= self.window.frame.size.height;
	NSPoint nspoint = NSPointFromCGPoint(p);
	[self.window setFrameOrigin:nspoint];
}

#pragma mark -

- (IBAction)enable:(id)sender
{
	enabled = !enabled;
	if (enabled) {
		[self startTracking];
	}
	else {
		[self endTracking];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(enable:)) {
		[menuItem setState:enabled];
		return YES;
	}
	return YES;
}

#pragma mark -


CGEventRef MyEventTapCallBack (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
	@autoreleasepool {
		BCAppDelegate *self = (__bridge BCAppDelegate *)(refcon);
		CGPoint p = CGEventGetLocation(event);
		[self moveWindowToPoint:p];
	}
	return event;
}

@end
