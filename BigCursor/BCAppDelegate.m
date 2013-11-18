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
}

- (void)dealloc
{
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
	[self startTracking];
}

- (void)startTracking
{
	if (!eventTapPortRef) {
		eventTapPortRef = CGEventTapCreate(kCGSessionEventTap, kCGTailAppendEventTap, 0, CGEventMaskBit(kCGEventMouseMoved), MyEventTapCallBack, (__bridge void *)(self));
	}
	if (!source) {
		source = CFMachPortCreateRunLoopSource(NULL, eventTapPortRef, 0);
		CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
	}
	if (!CGEventTapIsEnabled(eventTapPortRef)) {
		CGEventTapEnable(eventTapPortRef, YES);
	}
}

- (void)endTracking
{
	if (eventTapPortRef) {
		CGEventTapEnable(eventTapPortRef, NO);
	}
}


CGEventRef MyEventTapCallBack (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
	@autoreleasepool {
		BCAppDelegate *self = (__bridge BCAppDelegate *)(refcon);
		CGPoint p = CGEventGetLocation(event);
		p.y = [[NSScreen mainScreen] frame].size.height - p.y;
		p.y -= self.window.frame.size.height;
		NSPoint nspoint = NSPointFromCGPoint(p);
		[self.window setFrameOrigin:nspoint];
		if (!self.window.isVisible) {
			[self.window orderFront:nil];
		}
	}
	return event;
}

@end
