#import "BCWindow.h"

@implementation BCWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];

	if (self) {
		self.backgroundColor = [NSColor clearColor];
		self.movableByWindowBackground = NO;
		self.excludedFromWindowsMenu = YES;
		self.alphaValue = 1.0;
		self.opaque = NO;
		self.hasShadow = YES;
		[self useOptimizedDrawing:YES];
		[self setLevel:CGShieldingWindowLevel() + 1];
	}
	return self;
}

@end
