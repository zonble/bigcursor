#import "BCWindow.h"

@implementation BCWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];

	if (self) {
//		[self setAcceptsMouseMovedEvents:YES];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setMovableByWindowBackground:NO];
		[self setExcludedFromWindowsMenu:YES];
		[self setAlphaValue:1.0];
		[self setOpaque:NO];
		[self setHasShadow:YES];
		[self useOptimizedDrawing:YES];
		[self setLevel:CGShieldingWindowLevel() + 1];
	}
	return self;
}
//
//- (BOOL)canBecomeKeyWindow
//{
//	return NO;
//}
//
//- (BOOL)canBecomeMainWindow
//{
//	return NO;
//}


@end
