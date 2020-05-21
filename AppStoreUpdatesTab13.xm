#import "AppStoreUpdatesTab13.h"

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
