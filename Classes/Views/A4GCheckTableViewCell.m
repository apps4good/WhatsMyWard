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

#import "A4GCheckTableViewCell.h"
#import "NSString+A4G.h"

@interface A4GCheckTableViewCell ()

@end

@implementation A4GCheckTableViewCell

typedef enum {
	CheckedFalse,
	CheckedTrue
} Checked;

@synthesize delegate = _delegate;
@synthesize indexPath = _indexPath;
@synthesize checkBox = _checkBox;
@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;

- (id)initWithReuseIdentifier:(NSString *)identifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void) setChecked:(BOOL)isChecked {
	if (isChecked) {
		self.tag = CheckedTrue;
        [self.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateHighlighted];
	}
	else {
        self.tag = CheckedFalse;
		[self.checkBox setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateHighlighted];
	}
}

- (BOOL) checked {
    return self.tag == CheckedTrue;
}

- (IBAction) checked:(id)sender {
    self.checked = !self.checked;
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(checkTableViewCellChanged:index:checked:)]) {
        [self.delegate checkTableViewCellChanged:self index:self.indexPath checked:self.checked];
	}
}

+ (CGFloat) cellHeight {
    return 44;
}

- (void)dealloc {
    _delegate = nil;
    [_checkBox release];
    [_indexPath release];
    [_titleLabel release];
    [_subtitleLabel release];
    [super dealloc];
}

@end
