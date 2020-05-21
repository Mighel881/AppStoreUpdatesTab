#import "AppStoreUpdatesTab13.h"

#define IS_iPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

BOOL addedGestureRecognizer = NO;

%hook UITabBar

- (void)layoutSubviews
{
	%orig;

	for(UIView *subview in [self subviews])
	{
		if([subview isKindOfClass: %c(UITabBarButton)])
		{
			UITabBarButton *button = (UITabBarButton*)subview;
			UITabBarButtonLabel *label = MSHookIvar<UITabBarButtonLabel*> (button, "_label");
			
			if([[label text] isEqualToString: @"Arcade"])
			{
				[label setText: @"Updates"];
				[label setAdjustsFontSizeToFitWidth: YES];
				if(IS_iPAD)
					[label setTextAlignment: NSTextAlignmentLeft];
				else
					[label setTextAlignment: NSTextAlignmentCenter];
				[label setUpdatesTab: @YES];

				[MSHookIvar<UITabBarSwappableImageView*> (button, "_imageView") setImage: [UIImage imageWithContentsOfFile: @"/var/mobile/Library/com.johnzaro.AppStoreUpdatesTab13.bundle/UpdatesTabIcon-38-56-.png"]];
				
				if(!addedGestureRecognizer)
				{
					[button addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openUpdates)]];
					addedGestureRecognizer = YES;
				}
			}
		}
	}
}

%new
- (void)openUpdates
{
	[[%c(UIApplication) sharedApplication] openURL: [NSURL URLWithString: @"itms-apps://apps.apple.com/updates"]];
}

%end

%hook UITabBarButtonLabel

- (void)setFrame: (CGRect)frame
{
	id updatesTab = [self updatesTab];
	if([updatesTab isEqual: @YES])
	{
		if(IS_iPAD)
			frame.size.width = 51;
		else
			frame.size.width = 42;
	}
	%orig;
}

%new
- (id)updatesTab
{
	return (id)objc_getAssociatedObject(self, @selector(updatesTab));
}

%new
- (void)setUpdatesTab: (id)arg
{
	objc_setAssociatedObject(self, @selector(updatesTab), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end
