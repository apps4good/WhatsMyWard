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

#import "A4GHeaderView.h"
#import "A4GDevice.h"

@interface A4GHeaderView ()

+ (CGFloat) getPaddingForTable:(UITableView *)tableView;

@end

@implementation A4GHeaderView

+ (id)headerForTable:(UITableView *)tableView text:(NSString *)text {
	return [[[A4GHeaderView alloc] initForTable:tableView text:text textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]] autorelease];
}

+ (id)headerForTable:(UITableView *)tableView text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
	return [[[A4GHeaderView alloc] initForTable:tableView text:text textColor:textColor backgroundColor:backgroundColor] autorelease];
}

- (id)initForTable:(UITableView *)tableView text:(NSString *)theText textColor:(UIColor *)theTextColor backgroundColor:(UIColor *)theBackgroundColor {
	CGRect theFrame = CGRectMake(0.0, 0.0, tableView.bounds.size.width, 24.0);
    if (self = [super initWithFrame:theFrame]) {
		self.backgroundColor = theBackgroundColor;
		self.opaque = YES;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = theBackgroundColor;
		label.opaque = YES;
		label.textColor = theTextColor;
		label.font = [UIFont boldSystemFontOfSize:16];
		CGFloat padding = [A4GHeaderView getPaddingForTable:tableView];
		label.frame = CGRectMake(padding, 0.0, theFrame.size.width - padding, theFrame.size.height);
		label.text = theText;
		label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		[self addSubview:label];
		[label release];
	}
    return self;
}

+ (CGFloat) getPaddingForTable:(UITableView *)tableView {
	if ([A4GDevice isIPad]) {
        if (tableView.style == UITableViewStylePlain) {
            return 10;
        }
        return tableView.contentSize.width > 320 ? 50 : 18;
	}
	return tableView.style == UITableViewStylePlain ? 10 : 15;
}

- (void)dealloc {
	[super dealloc];
}

- (void) setText:(NSString *)text {
	UILabel *label = (UILabel *)[self.subviews objectAtIndex:0];
	if (label != nil && [label isKindOfClass:[UILabel class]]) {
		[label setText:text];
	}
}

+ (CGFloat) getViewHeight {
	return 24;
}
@end
