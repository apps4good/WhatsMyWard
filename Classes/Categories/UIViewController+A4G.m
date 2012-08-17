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

#import "UIViewController+A4G.h"
#import "A4GSettings.h"

@implementation UIViewController (A4G)

- (void) animatePageCurlUp:(CGFloat)duration {
    [self animatePageCurl:YES fillMode:kCAFillModeForwards type:@"pageCurl" duration:duration];
}

- (void) animatePageCurlDown:(CGFloat)duration {
    [self animatePageCurl:NO fillMode:kCAFillModeBackwards type:@"pageUnCurl" duration:duration];
}

- (void) animatePageCurl:(BOOL)up fillMode:(NSString*)fillMode type:(NSString*)type duration:(CGFloat)duration {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self]; 
    [animation setDuration:duration];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    animation.type = type;
    animation.fillMode = fillMode;
    if (up) {
        animation.endProgress = 0.50;
    }
    else {
        animation.startProgress = 0.55;
    }
    [animation setRemovedOnCompletion:NO];
    for (UIView *subView in self.view.subviews) {
        DLog(@"Before:%@", subView.class);
    }
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [[self.view layer] addAnimation:animation forKey:@"pageCurlAnimation"];
}

- (BOOL) isTopView:(UIView *)view {
    return [[self.view subviews] lastObject] == view;
}

- (CGRect) touchOfEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGRect rect;
    rect.origin.x = location.x;
    rect.origin.y = location.y;
    rect.size.width = 5;
    rect.size.height = 5;
    return rect;
}

+ (NSString *)stringByAppendingPathComponents:(NSString *)string, ... {
    va_list args;
    va_start(args, string);
	NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [filePaths objectAtIndex:0];
	for (NSString *arg = string; arg != nil; arg = va_arg(args, NSString*)) {
		if (arg != nil && [arg length] > 0) {
			filePath = [filePath stringByAppendingPathComponent:arg];
		}
	}
	va_end(args);
	return filePath;
}

- (UIBarButtonItem *) barButtonWithItems:(UIBarButtonItem*)item, ... {
    va_list args;
    va_start(args, item);
    UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.01f)] autorelease]; 
    toolbar.clearsContextBeforeDrawing = NO;
    toolbar.clipsToBounds = NO;
    toolbar.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f];
    toolbar.barStyle = -1; 
    NSMutableArray *buttons = [ NSMutableArray arrayWithCapacity:3];
    for (UIBarButtonItem *arg = item; arg != nil; arg = va_arg(args, UIBarButtonItem*)) {
        if ([arg respondsToSelector:@selector(setTintColor:)]) {
            arg.tintColor = [A4GSettings navBarColor];
        }
        [buttons addObject:arg];
    }
    va_end(args);
    [toolbar setItems:buttons animated:NO];
    
    double width = [toolbar.items count] > 1 ? 12.0 : 0.0;
    for(int i = 0; i < [toolbar.subviews count]; i++){
        UIView *view = (UIView *)[toolbar.subviews objectAtIndex:i];
        width += view.bounds.size.width;
    }
    CGSize size = toolbar.frame.size;
    size.width = width;
    toolbar.frame = CGRectMake(0, 0, size.width, size.height);
    
    return [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
}

@end
