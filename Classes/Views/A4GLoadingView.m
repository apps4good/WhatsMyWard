// ##########################################################################################
// 
// Copyright (c) 2012, Apps4Good. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are 
// permitted provided that the following conditions are met:
// 
// 1) Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
// 2) Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
// 3) Neither the name of the Apps4Good nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
// SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// ##########################################################################################

#import "A4GLoadingView.h"

@interface A4GLoadingView ()
@property (nonatomic, retain) UIViewController *controller;

- (void) removeFromSuperviewAnimated;
- (void) removeFromSuperviewAfterDelay:(NSNumber*)delay;

@end

@implementation A4GLoadingView

@synthesize controller = _controller;
@synthesize activityIndicator = _activityIndicator;
@synthesize activityIndicatorLabel = _activityIndicatorLabel;
@synthesize activityIndicatorBackground = _activityIndicatorBackground;

+ (A4GLoadingView*) initWithController:(UIViewController *)controller {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GLoadingView" owner:controller options:nil];
    A4GLoadingView *loadingView = (A4GLoadingView*)[objects lastObject];
    loadingView.activityIndicatorBackground.layer.cornerRadius = 20.0f;
    loadingView.controller = controller;
    loadingView.center = controller.view.center;
    return loadingView;
}

- (void)dealloc {
	[_controller release];
	[_activityIndicator release];
	[_activityIndicatorLabel release];
    [_activityIndicatorBackground release];
	[super dealloc];	
}

- (void) show {
	[self showWithMessage:NSLocalizedString(@"Loading...", nil) afterDelay:0.0 animated:YES];
}

- (void) showAfterDelay:(NSTimeInterval)delay {
	[self showWithMessage:NSLocalizedString(@"Loading...", nil) afterDelay:delay animated:YES];
}

- (void) showWithMessage:(NSString *)message {
	[self showWithMessage:message afterDelay:0.0 animated:YES];
}

- (void) showWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
	[self showWithMessage:message afterDelay:delay animated:YES];
}

- (void) showWithMessage:(NSString *)message animated:(BOOL)animated {
	[self showWithMessage:message afterDelay:0.0 animated:animated];
}

- (void) showWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
	if ([NSThread isMainThread]) {
        if (self.superview == nil) {
            [self.controller.view performSelector:@selector(addSubview:) withObject:self afterDelay:delay];
			self.alpha = 1.0;
			self.center = self.controller.view.center;
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		}
		self.activityIndicator.hidden = !animated;
        self.activityIndicatorLabel.text = message;
	}
	else {
        if (self.superview == nil) {
			[self.controller.view performSelectorOnMainThread:@selector(addSubview:) withObject:self waitUntilDone:NO];
			[self performSelectorOnMainThread:@selector(centerView) withObject:nil waitUntilDone:NO];
            [self.activityIndicatorLabel performSelectorOnMainThread:@selector(setText:) withObject:message waitUntilDone:NO];
		}
		[self.activityIndicatorLabel performSelectorOnMainThread:@selector(setText:) withObject:message waitUntilDone:NO];
	}
}

- (void)centerView {
    self.center = self.controller.view.center;
}

- (void) hide {
	[self hideAfterDelay:0.0];
}

- (void) hideAfterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self performSelector:@selector(removeFromSuperviewAnimated) withObject:nil afterDelay:delay];
	}
	else {
        [self performSelectorOnMainThread:@selector(removeFromSuperviewAfterDelay:) withObject:[NSNumber numberWithFloat:delay] waitUntilDone:NO];
    }
}

- (void) removeFromSuperviewAfterDelay:(NSNumber*)delay {
    [self performSelector:@selector(removeFromSuperviewAnimated) withObject:nil afterDelay:[delay floatValue]];
}

- (void) removeFromSuperviewAnimated {
    [UIView beginAnimations:@"removeFromSuperview" context:nil];
	[UIView setAnimationDuration:0.3];
	self.alpha = 0.0;
	[UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];	
}

@end

