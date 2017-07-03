#import <AppKit/AppKit.h>
#import <Sparkle/Sparkle.h>

@class SUUpdateAlert;

@interface ComBelkadanWebmailer_UpdateController : SUUpdater {
	IBOutlet NSImageView *updateIconView;
	IBOutlet NSView *updateBar;
	IBOutlet NSView *mainView;

	SUAppcastItem *availableUpdate;
	SUUpdateAlert *updateAlert;
	BOOL hasPerformedInitialCheck;
}

- (IBAction)showReleaseNotes:(id)sender;
- (IBAction)installUpdate:(id)sender;
@end
