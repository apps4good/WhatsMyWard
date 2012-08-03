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

#import "A4GSwitchTableViewCell.h"

@implementation A4GSwitchTableViewCell

@synthesize indexPath = _indexPath;
@synthesize titleLabel = _titleLabel;
@synthesize detailsLabel = _detailsLabel;
@synthesize switchView = _switchView;
@synthesize delegate = _delegate;

- (void) setTitle:(NSString *)title {
	self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void) setDetails:(NSString *)details {
    CGRect frame = self.titleLabel.frame;
    if (details != nil) {
        frame.origin.y = self.detailsLabel.frame.origin.y - self.titleLabel.frame.size.height;
    }
    else {
        frame.origin.y = self.frame.size.height/2 - self.titleLabel.frame.size.height/2;
    }
    self.titleLabel.frame = frame;
    self.detailsLabel.text = details;
}

- (NSString *)details {
    return self.detailsLabel.text;
}

- (void)setOn:(BOOL)on {
	self.switchView.on = on;
}

- (BOOL)on {
    return self.switchView.on;
}

- (IBAction) changed:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(switchTableViewCell:index:on:)]) {
        [self.delegate switchTableViewCell:self index:self.indexPath on:self.switchView.on];
	}
}

- (void)dealloc {
    _delegate = nil;
    [_indexPath release];
    [_titleLabel release];
    [_detailsLabel release];
    [_switchView release];
    [super dealloc];
}

@end
